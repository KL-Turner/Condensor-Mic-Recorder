# VI to acquire sound from a Condensor Microphone

This VI is designed to run a short DAQ for evaluating noise levels in imaging areas. This README serves to explain how to use the VI for data acquisition and explain some of the results of the sounds caused during two-photon excitation microscopy. Laboratory animal's auditory range is significantly different than that of humans, and the (negative) effects of high-frequency noise in animal housing environments has been documented. 

| ![](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3725606/bin/nihms2489f3.jpg) |
|:--:|
| *Figure 1: Auditory comparison for humans and common laboratory animals.* |

##### See: Journal of the American Association for Laboratory Animal Science, Volume 46, Number 1, January 2007, pp. 10-13(4) by Turner (good work, but not from me) et al. https://www.ncbi.nlm.nih.gov/pubmed/17203909 and https://www.ncbi.nlm.nih.gov/pubmed/15766204 (Figure 3)

Human hearing ranges from ~ 20-20kHz, represented by the black dashed line in Figure 1. Most mammalian hearing curves represent an approximate "U" shape, with the frequencies in the center being the most sensitive; i.e. you can still hear them at a *quieter* volume. In most humans, this typically peaks between 2-5 kHz. Perhaps not surprisingly, this range is *exactly* the frequency range of a human baby crying - typically centering around 3.5 kHz. 

In many other mammals, particularly those used in scientific research, have hearing ranges whose frequencies are typically shifted to the right (higher). As shown in figure 3, a laboratory mouse's hearing range extends from approximately 1 kHz to 100 kHz with sensitivity peaks around 12-25kHz. This difference in hearing range between humans and laboratory animals (particularly mice) makes it difficult to understand how imperceivable and/or inaudible  high-frequency noise can be present. An otherwise silent environment for us may appear as a comparative rock concert for an animal. This issue is further exacerbated by the tendency of high-frequency hearing sensitivity to deteriorate with age. By age 40, most humans can only hear below 15 kHz. Around age 50, 12 kHz. While nearly all humans can accurately perceive up to 8 kHz, the sensitivity to high-frequencies and their perceived "volume" is highly variable.

Since our lab is interested in studying various aspects of neurovascular coupling during sleep states, it is imperitive for us to do our best to cater to the animal's hearing sensitivity. While it is beneficial that our normal talking voices, typically in the hundreds of Hz (unless singing) are likely completely inaudible to a mouse, there are a plethora of potentially high-pitch sounds from various computers, scannings mirrors, pumps, fans, and other equipment that go unnoticed. For these reasons described above, the following VI and corresponding sample data demonstrate a real-world example of these concepts during our experiments. 

## Condensor Microphone VI - Front Panel

| ![](https://user-images.githubusercontent.com/30758521/56699993-e9495b00-66c5-11e9-9b85-5131646aca7d.PNG) |
|:--:|
| *Figure 2: Front Panel for Condensor Microphone VI.* |

### Equipment

| Hardware, Manufacture                         | Documentation                                                                                                | Purpose                                             |
| :---                                          | :---                                                                                                         | :---                                                |
| Avisoft CM16/CMPA24AAf-5V     | https://www.avisoft.com/usg/cm16_cmpa.htm                                            | Condensor Microphone                                    |
| National Instruments USB-6343                | http://www.ni.com/en-us/support/model.usb-6343.html                                                         | DAQ device            |

This VI uses a few Express VIs for convenience, but unfortunately don't have a clean way of adding those controls to the front panel. On the front panel, you can adjust the time bewteen 1 and 60 seconds, and can easily increase the value by adjusting the gauge properties. A purple LED will illuminate once the microphone starts recording data, and will shut off with the illumination of a blue light when data acquisition is completed. The sampling rate can be adjusted in the Analog Fs box. Verify your specific device's maximum sampling rate. To not alias the mouse's hearing range, you need at *least* 200kS/s. A filepath box allows you to determine the file-save location. Each file is automatically named YYMMDD_HH_MM_SS, so each will have a unique file name regardless of duration. To change the save directory, type the filepath into the designated field.

 The condensor microphone has 4 input wires - PWR (+5), GRND, and an Analog (+) and Analog (-). Nearly all NI boards have power and ground pins, and most have serveral analog input (AI) pins for analog differential recording. Consult your device's pinout for specifications. 

While the acquisition duration, sampling rate, and filepath can be set-up and adjusted on the front panel, you need to tell the Express VI which device and analog pin you're connected to. To do this, you have to enter the block diagram. To do this, hit CTL+T.

| ![](https://user-images.githubusercontent.com/30758521/56695095-4b9a5f80-66b6-11e9-9cdf-1b824b5f78c9.png) |
|:--:|
| *Figure 3: Block Diagram. Emphasis on DAQ Assistant Block.* |

## **Double-click the block titled "DAQ Assistant" (located in center-top of diagram)**

| ![](https://user-images.githubusercontent.com/30758521/56695152-6076f300-66b6-11e9-8bb7-c7b4e68777d9.PNG) |
|:--:|
| *Figure 4: Panel to adjust Device/Physical channel input.* |

A menu in the DAQ Assistant will pop up and give you access to the different parameters. The *only* parameter that you have to change is the Device/Physical Channel. You do this by right clicking the "Voltage" Channel setting and selecting *Change Physical Channel*. You device should be present, and you can select the correct analog channel from the drop-down menu. After selecting, click *OK* and then *OK* again at the bottom of the DAQ Assistant menu. The menu will then close, and the Block Diagram will update (temporarily breaking all the wires) and the re-assemble. 

Note: You can see the Acquisition mode, samples to read, and Rate (Hz) fields. There's also a File save path option if you go exploring. You can change these, but it will not do anything. The front panel values override whatever you put in these fields. When you close the DAQ Assistant menu, you may get an error warning you that things will not work in their current state. Disregard the warning, and return to the front panel as the "errors" are corrected with the front panel's input parameters. 

While there is a "device name" wire terminal in the Express VI's block, I was unable to simply find a way to add the actual *physical channel* to avoid having to actually enter the DAQ Assistant. Nonetheless, this method works. 

## Sample Results
| ![](https://user-images.githubusercontent.com/30758521/56777792-4a922c80-67a1-11e9-8895-24cb55aa220b.PNG) |
|:--:|
| *Figure 5: Spectral analysis of different scanning rates + background noise.* |

An in-house experiment was run to compare the high-frequency noise generated by the different image-rastering (scanning rates) of the Galvo-Galvo scan mirrors during two-photon imaging. A sampling rate of 200kHz was used to satisfy the Nyquist frequency of the mouse's hearing range. Four different five-minute acquisitions were acquired with continuous sound i.e. scanning was started before the microphone VI was ran, and continued throughout the entire duration. There were no external noises or disruptions, as these experiments were performed late at night with nobody else in the lab. It is important to note that there is significant background noise caused by the Two-photon cooling pumps, numerous computer fans, and multiple dehumidifiers to name a few. These likely cause the consistent harmonics seen in the power spectra of Figure 5. The most important aspect is to notice the high-frequency differences centering around 10<sup>4</sup> (10,000) kHz. As previously mentioned, these high-frequency sounds are audible to human's, but our ears are much less sensitive. Meanwhile, this lies directly in the most sensitive range of a mouse's hearing.

The differences in spectral power between the different scanning rates is significant, and likely contributes in large degree to animal distress and fear, particularly during the initial days of imaging. For these reasons, it would be beneficial to habituate the animals with the scanning mirrors running (laser off, shutter closed) from Day 1. In personal experience with experiments designed to collect sleep data, the animals are considerably more calm during slower acquisition rates at larger frame sizes. Scanning a small area at 20 Hz not only increases the risk of heating artifacts, but continuously causes *excessive* animal whisking and struggling movements even after 5 days of habituation and 6 days of (3+) hours of imaging, with absolutely zero sleep (or even drowsy-state) behavior.

To be added at a later date - Comparable set of data from another two-photon setup that uses resonant-scanning and one Galvo instead of two.

Matlab script (CondensorMicDataAnalysis.m) and supporting Chronux scripts (http://chronux.org/) to analyze the microphone data are included in this folder with the DAQ VI.

Contact klt8@psu.edu with any questions.