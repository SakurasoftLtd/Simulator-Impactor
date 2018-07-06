# Simulator Impactor

## About

Simulator Impactor is a lightweight Mac app that allows you to install and run pre-compiled iOS apps in the simulator, without the use of Xcode. This is particularly useful when distributing builds to test teams or business development teams as they can preview the app without the need for a physical device or access to source control.

## Prerequesites

- macOS 10.12 or higher
- Xcode 8 or higher
- Xcode command line tools
- A binary of your app **compiled for amd64**. (This one is important, you should note that iOS devices utilise the *armv7* architecture which is **not** compatible with modern Macs that utilise the *amd64* architecture. It is therefore necessary to note that standard archives exported in `.ipa` format will **not** work with Simulator Impactor. Please see footnote 1 for more info.)

## How to Install

Clone the project and open in Finder. Inside the root directory you will find a `bin` folder which contains a compiled binary of the latest version, codesigned by us. You may run and use this, or, alternatively, compile the project from source with your own codesigning.

## How to Use

Simulator Impactor is designed with ease of use in mind. When you launch the tool, you will be greeted by this interface.

![](https://i.imgur.com/pVJirFp.png)

Simply select a simulator from the drop down,

![](https://i.imgur.com/V6Eks8k.png)

Then choose your `.app` file,

![](https://i.imgur.com/366D5Dq.png)

And you're ready to go. Hit launch to begin. The utility will now close all open simulators and launch the one which you selected. After it boots, you will see your app installing and subsequently launching.

Should this not happen, please check the help screen of the tool, accessible by clicking the 'Help' button.

## Contributing

If you feel like you can improve this tool then by all means get involved and submit a PR!

## Footnotes

1. It is easy to produce builds for `amd64`. Any build compiled in a developer environment for the simulator is suitible. Simply locate your app in the build products folder, and use that in the tool.<br>Alternatively, if you use a build machine, simply include a command line argument to set the build architecture and omit the archive export step. The product you receive from this will be suitible.

## Credits

Simulator Impactor was built and is maintained by [Militia Softworks Ltd](http://www.militiasoftworks.co.uk/).
