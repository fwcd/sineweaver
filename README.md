# Sineweaver

A modular synthesizer featuring an interactive introduction.

<div align="center">
<p>
<img alt="Logo" src="Icons/AppIconRounded.svg" width="80">
</p>

<p>
<img alt="Screenshot" src="Screenshots/Screenshot.png" width="600">
</p>
</div>

## Project Structure

The project is packaged in two main ways:

- As a playground in [`Sineweaver.swiftpm`](Sineweaver.swiftpm), which includes both the tutorial and a standalone version of the synthesizer. This was my WWDC submission.
- As an Audio Unit instrument in [`SineweaverAU`](SineweaverAU), which includes a small AU host (for testing and as required e.g. on iOS), along with an app extension that includes the AU component which can be used from other AU hosts like Logic.

Currently only the AU version supports MIDI input (see [#9](https://github.com/fwcd/sineweaver/issues/9)).

## Description

Sineweaver aims to provide an introduction to modular synthesizers, a class of instruments that plays a central role in electronic music, but which traditional music education rarely focuses on. The user is guided step-by-step through the different components, building up to a final stage featuring a fully customizable synth. Additionally, a number of presets are included to showcase how different instruments (e.g. drums, strings, flutes or brass instruments) can be created from scratch using just synthesizer primitives.

The app makes heavy use of SwiftUI and Combine for the UI layer, along with AVFoundation for its custom-built audio engine. SwiftUI is really nice due to its high-level, declarative approach to UI, including effortless support for animation. AVFoundation on the other hand gives the app sample buffer-level control over the audio output, which is perfect for our synthesizer that heavily relies on generating custom samples.

No AI tools were used in the making of this app.

## Open Source

The project includes source code from my own MIT-licensed libraries [`swift-music-theory`](https://github.com/fwcd/swift-music-theory) and [`swift-utils`](https://github.com/fwcd/swift-utils).
