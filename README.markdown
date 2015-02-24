DejalObject
===========

DejalObject is an abstract data model class that can represent subclasses as dictionary or JSON data for saving to disk or over the network.

Included are DejalColor, DejalDate and DejalInterval concrete subclasses.

They work on both OS X and iOS.


Donations
---------

I wrote DejalObject for my own use, but I'm making it available for the benefit of the Mac and iOS developer community.

If you find it useful, a donation via PayPal (or something from my Amazon.com Wish List) would be very much appreciated. Appropriate links can be found on the Dejal Developer page:

<http://www.dejal.com/developer>


Latest Version
--------------

You can find the latest version of this code via the GitHub repository:

<https://github.com/Dejal/DejalObject>

For news on updates, also check out the Dejal Developer page or the Dejal Blog filtered for DejalObject posts:

<http://www.dejal.com/blog/dejalobject>


Environment & Requirements
--------------------------

- All recent versions of OS X or iOS.
- Objective-C language.
- ARC.


Features
--------

- **DejalObject**: This is an abstract subclass of `NSObject` that adds methods to represent the receiver as a dictionary or JSON data, load default values, track changes, enumerate an array of `DejalObject` instances, and more.
- **DejalColor**: A concrete subclass of `DejalObject` to represent a color (for OS X or iOS), enabling it to be stored in a `DejalObject` subclass.
- **DejalDate**: Another concrete subclass to represent a date, primarily so it can automatically be represented as JSON.
- **DejalInterval**: A subclass to represent a time interval or a range of intervals, including an amount and units, with methods to represent the interval or range in various ways, including as human-readable strings (see also the `DejalIntervalPicker` project for OS X).

A demo project is included, showing a subclass of `DejalObject` to store various data types.


Usage
-----

Include at least DejalObject.h and DejalObject.m in your project.  Include the `DejalColor`, `DejalDate` and/or `DejalInterval` files if those are needed.

Add a new class that inherits from `DejalObject`.

In the header, you only need to define properties to store, e.g.:

    @interface Demo : DejalObject
    
    @property (nonatomic, strong) NSString *text;
    @property (nonatomic) NSInteger number;
    @property (nonatomic, strong) DejalColor *label;
    @property (nonatomic, strong) DejalDate *when;
    
    @end

In the implementation, override `-initWithCoder:` and `-encodeWithCoder:` if you need to support coding (secure coding is supported in `DejalObject`).

Override `-loadDefaultValues` to populate default values to each of the properties.  A version number can be assigned (via `DejalObject`'s `version` property) to enable upgrading later, e.g.:

    - (void)loadDefaultValues;
    {
        [super loadDefaultValues];
        
        self.version = DemoVersion;
        self.text = @"Foo";
        self.number = 12345;
        self.label = [DejalColor colorWithColor:[NSColor blueColor]];
        self.when = [DejalDate dateWithNow];
    }

Finally, override `-savedKeys` to indicate which properties should be automatically included in the dictionary or JSON representation, e.g.:

    - (NSArray *)savedKeys;
    {
        return [[super savedKeys] arrayByAddingObjectsFromArray:@[@"text", @"number", @"label", @"when"]];
    }

A `DejalObject` subclass can be represented as a `NSDictionary` simply by invoking the `dictionary` property on it, or as JSON via the `json` property.  That can then be saved to disk or the user defaults, or passed over the network.

Those properties can also be set, or a new instance can be created via `+objectWithDictionary:` or `+objectWithJSON:`, or an instance with default values via `+object`.

`DejalObject` instances automatically track changes, with a `hasChanges` BOOL property indicating that something has changed (so may need to be saved).  There is also a `hasAnyChanges` property that recursively enumerates the properties and any other `DejalObject` instances in them, e.g. if the color is changed in the above example.

After saving, you should invoke `-clearChanges` to reset the change flag.


License and Warranty
--------------------

This code uses the standard BSD license.  See the included License.txt file.  Please also see the [Dejal Open Source License](http://www.dejal.com/developer/license/) web page for more information.

You can use this code at no cost, with attribution.  A non-attribution license is also available, for a fee.

You're welcome to use it in commercial, closed-source, open source, free or any other kind of software, as long as you credit Dejal appropriately.

The placement and format of the credit is up to you, but I prefer the credit to be in the software's "About" window or view, if any. Alternatively, you could put the credit in the software's documentation, or on the web page for the product. The suggested format for the attribution is:

> Includes DejalObject code from [Dejal](http://www.dejal.com/developer/).

Where possible, please link the text "Dejal" to the Dejal Developer web page, or include the page's URL: <http://www.dejal.com/developer/>.

This code comes with no warranty of any kind.  I hope it'll be useful to you, but I make no guarantees regarding its functionality or otherwise.


Support / Contact / Bugs / Features
-----------------------------------

I can't promise to answer questions about how to use the code.

If you create an app that uses the code, please tell me about it.

If you want to submit a feature request or bug report, please use [GitHub's issue tracker for this project](https://github.com/Dejal/DejalObject/issues).  Or preferably fork the code and implement the feature/fix yourself, then submit a pull request.

Enjoy!

David Sinclair  
Dejal Systems, LLC


Contact: <http://www.dejal.com/contact/?subject=DejalObject>
More open source projects: <http://www.dejal.com/developer>
Open source announcements on Twitter: <http://twitter.com/dejalopen>
General Dejal news on Twitter: <http://twitter.com/dejal>

