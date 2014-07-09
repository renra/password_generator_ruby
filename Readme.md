# Password Generator

A configurable strong-password generator wanna-be

##Installation

    gem install custom_password_generator

##How to use

First of all, require the gem:

    require 'password_generator'

By default the generator creates 8 character-long passwords which include at least one number, lower case character, upper case character and special character (like ! for example).

    PasswordGenerator.generate

But what if you want a 10 character-long passwords? Easy to do

    PasswordGenerator.generate(length: 10)

The rest of the defaults still applies. But maybe you don't really like the special characters and you don't want to watch your caps-lock to know whether you're typing lower or upper case characters. Then you'd do

    PasswordGenerator.generate(include_upper_case: false, include_special: false)

## Pools

```PasswordGenerator``` uses pools to group characters. For example the character 'a' is in a different pool than the character 'A'. There are four internal pools which you can turn off by specifying

    include_upper_case: false
    include_lower_case: false
    include_special: false
    include_nums: false

All the four pools are included by default. If you use all these four options at the same time ```PasswordGenerator``` will throw an error because it will have an empty pool. Unless you use the following:

## Custom Pools

The fifth pool you can use is your own. Here's how:

    PasswordGenerator.generate(pool: ('d'..'x').to_a)

With this setup the password will consist only of characters from 'd' to 'x'. Of course you can give it a simple array to cherry-pick just the characters you want. But remember that the less characters your pool has, the weaker your password is. (For example ```PasswordGenerator.generate(pool: ['a'])``` will give you just 8 'a's).

If you use a custom pool, the four internal pools will not be used by default. If you still want them to be used you can use the options specified above

    PasswordGenerator.generate(pool: [':'], include_lower_case: true)

As always, PasswordGenerator tries to include at least one character from each pool. The only case this is not guaranteed is when the password length is less than the number of pools. In that case the pool, just as the character from that pool, is selected pseudo-randomly for each character. No guarantees.

## PasswordGenerator.opts_for

If you want to limit your selection to just one pool, it would be tedious to name all the options. You can use ```opts_for``` to give you a shorthand syntax:

    PasswordGenerator.generate(PasswordGenerator.opts_for(:lower))
    PasswordGenerator.generate(PasswordGenerator.opts_for(:lower, 12))

The first parameter can be :numeric, :lower, :upper, :special, :alpha, :alnum or :all. The second parameter is an optional length of the resulting password. So the code above generates passwords using only lower case characters.

## Excluding characters

But what should you do when you want to use all normal characters except 'x'? Easy enough:

    PasswordGenerator.generate(exclude: ['x'])

Now 'x' will never be used. You might want to use exclude to limit the special chars depending on your needs. Again, if you exclude all characters from all your pools, ```PasswordGenerator``` will complain.

## Re-using generators

```PasswordGenerator.generate(options)``` is a shorthand syntax for

    PasswordGenerator.new(options).generate

Which means you can create just one generator with the right setup for your project and then just keep calling ```generate``` just on this one generator.

## Composite passwords

Okay, time to get wet. What if I have really complicated requirements on my passwords? What if my password cannot have any special character on the first two places, then it must contain 7 numbers and then precisely one special character, one number again and either 'x' or 'y' at the end? (I'm making the requirements a little crazy on purpose). Not too hard to do either:

    PasswordGenerator.generate(
      PasswordGenerator.opts_for(:alnum, 2),
      PasswordGenerator.opts_for(:numeric, 7),
      PasswordGenerator.opts_for(:special, 1),
      PasswordGenerator.opts_for(:numeric, 1),
      {
        pool: ['x', 'y']
        length: 1
      }
    )

Of course you can create each generator using ```new``` and then just concatenate the results of their ```generate``` method. In fact ```PasswordGenerator.generate``` does exactly that behind the scenes.

Good luck using ```PasswordGenerator``` :-)
