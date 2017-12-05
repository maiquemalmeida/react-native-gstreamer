import React from 'react'
import { requireNativeComponent, View, UIManager, findNodeHandle, AppState } from 'react-native'

const PropTypes = require('prop-types')

export const states = {
    NULL: 'GST_STATE_NULL',
    READY: 'GST_STATE_READY',
    PAUSED: 'GST_STATE_PAUSED',
    PLAYING: 'GST_STATE_PLAYING',
}

export default class GstPlayer extends React.PureComponent {

    currentGstState = undefined
    appState = "active"

    constructor(props, context) {
        super(props, context)
    }

    componentDidMount() {
        this.playerHandle = findNodeHandle(this.playerViewRef)
        AppState.addEventListener('change', this.appStateChanged)
    }

    componentDidUpdate(oldProps) {

    }

    componentWillUnmount() {
        AppState.removeEventListener('change', this.appStateChanged)
    }

    appStateChanged = (nextAppState) => {
        if (this.appState.match(/inactive|background/) && nextAppState === 'active') {
            this.setState(states.PLAYING)
        } else {
            this.setState(states.PAUSED)
        }
        this.appState = nextAppState
    }

    _refreshScreen() {
        UIManager.dispatchViewManagerCommand(
            this.playerHandle,
            UIManager.GstPlayer.Commands.refreshScreen,
            null
        )
    }

    _flushBuffers() {
        UIManager.dispatchViewManagerCommand(
            this.playerHandle,
            UIManager.GstPlayer.Commands.flushBuffers,
            null
        )
    }

    onAudioLevelChange(message) {
        const audio_level = message.nativeEvent.level
        if (!this.props.onAudioLevelChange)
            return

        this.props.onAudioLevelChange(audio_level)
    }

    onStateChanged(message) {
        const state = message.nativeEvent.state
        this.currentGstState = state

        if (!this.props.onStateChanged)
            return

        this.props.onStateChanged(state)
    }

    onReady() {
        if (this.props.onReady)
            this.props.onReady()

        this.play()
    }

    play() {
        if (this.currentGstState !== states.PLAYING)
            this.setState(states.PLAYING)
    }

    pause() {
        if (this.currentGstState !== states.PAUSED)
            this.setState(states.PAUSED)
    }

    stop() {
        if (this.currentGstState !== states.READY)
        this.setState(states.READY)
    }

    setState(state) {
        UIManager.dispatchViewManagerCommand(
            this.playerHandle,
            UIManager.GstPlayer.Commands.setState,
            [state]
        )
    }

    render() {
        const launchCmd = "rtspsrc location=" + this.props.uri + " latency=0 ! decodebin ! glimagesink"
        console.log(launchCmd)
        
        return (
            <RCTGstPlayer
                {...this.props}
                onAudioLevelChange={this.onAudioLevelChange.bind(this)}
                onStateChanged={this.onStateChanged.bind(this)}
                onReady={this.onReady.bind(this)}
                uri={this.props.uri}
                ref={(playerView) => this.playerViewRef = playerView}
                launchCmd={launchCmd}
            />
        )
    }
}
GstPlayer.propTypes = {

    // Events
    onAudioLevelChange: PropTypes.func,
    onStateChanged: PropTypes.func,
    onReady: PropTypes.func,

    // Methods
    play: PropTypes.func,
    pause: PropTypes.func,

    // Props
    uri: PropTypes.string,
    launchCmd: PropTypes.string,

    // Other
    ...View.propTypes
}

var RCTGstPlayer = requireNativeComponent('GstPlayer', GstPlayer, {
    nativeOnly: { onChange: true }
})