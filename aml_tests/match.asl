DefinitionBlock("out.aml", "DSDT", 1, "LAI", "LAI_TEST", 1)
{
	Scope(_SB)
	{
		Name(PKG1, Package(0x04){
			0x1, 0x2, 0x3, 0x4
		})

		Name(PKG2, Package(0x04){
			0x4, 0x3, 0x2, 0x1
		})

		Name(PKG3, Package(0x04){
			"ABCD", "ABCE", "ABCF", "ABCG"
		})

		Name(PKG4, Package(0x04){
			Buffer(0x04){0, 1, 2, 3}, Buffer(0x04){0, 1, 2, 4}, Buffer(0x04){0, 1, 2, 5}, Buffer(0x04){0, 1, 2, 6}
		})

		Method(INT_)
		{
			//! expect: (integer 0x1)
			Debug = Match(PKG1, MEQ, 0x2, MTR, 0x0, 0x0) // if(PKG1[i] == 2 && true) : Test Equal on existing item

			//! expect: (integer 0xFFFFFFFFFFFFFFFF)
			Debug = Match(PKG1, MEQ, 0x5, MTR, 0x0, 0x0) // if(PKG1[i] == 5 && true) : Test Equal on non-existing item

			//! expect: (integer 0x2)
			Debug = Match(PKG1, MGT, 0x2, MTR, 0x0, 0x2) // if(PKG1[i] > 2 && true) : Test Begin index

			//! expect: (integer 0x1)
			Debug = Match(PKG1, MGE, 0x2, MTR, 0x0, 0x0) // if(PKG1[i] >= 2 && true) : Test all comparisons

			//! expect: (integer 0x2)
			Debug = Match(PKG1, MGT, 0x2, MTR, 0x0, 0x0) // if(PKG1[i] > 2 && true)

			//! expect: (integer 0x1)
			Debug = Match(PKG2, MLE, 0x3, MTR, 0x0, 0x0) // if(PKG2[i] <= 3 && true)
			
			//! expect: (integer 0x2)
			Debug = Match(PKG2, MLT, 0x3, MTR, 0x0, 0x0) // if(PKG2[i] < 3 && true)

			//! expect: (integer 0x1)
			Debug = Match(PKG1, MGT, 0x1, MLT, 0x3, 0x0) // if(PKG1[i] > 1 && PKG1[i] < 0x3) : Test multiple ops
		}

		Method(STR_)
		{
			//! expect: (integer 0x0)
			Debug = Match(PKG3, MEQ, "ABCD", MTR, "", 0x0) // if(PKG3[i] == "ABCD" && true) : Test simple string equality

			//! expect: (integer 0x1)
			Debug = Match(PKG3, MGT, "ABCD", MTR, "", 0x0) // if(PKG3[i] > "ABCD" && true) : Test string comparison

			//! expect: (integer 0x0)
			Debug = Match(PKG3, MLE, "ABCD", MTR, "", 0x0) // if(PKG3[i] <= "ABCD" && true)

			//! expect: (integer 0x0)
			Debug = Match(PKG3, MLT, "ABCE", MTR, "", 0x0) // if(PKG3[i] < "ABCE" && true)

			//! expect: (integer 0x3)
			Debug = Match(PKG3, MGE, "ABCG", MTR, "", 0x0) // if(PKG3[i] >= "ABCG" && true)
		}

		Method(BUF_)
		{
			//! expect: (integer 0x0)
			Debug = Match(PKG4, MEQ, Buffer(0x04){0, 1, 2, 3}, MTR, "", 0x0) // if(PKG4[i] == Buffer(0x04){0, 1, 2, 3} && true) : Test simple buffer equality

			//! expect: (integer 0x1)
			Debug = Match(PKG4, MGT, Buffer(0x04){0, 1, 2, 3}, MTR, "", 0x0) // if(PKG4[i] > Buffer(0x04){0, 1, 2, 3} && true) : Test buffer comparison

			//! expect: (integer 0x0)
			Debug = Match(PKG4, MLE, Buffer(0x04){0, 1, 2, 3}, MTR, "", 0x0) // if(PKG4[i] <= Buffer(0x04){0, 1, 2, 3} && true)

			//! expect: (integer 0x0)
			Debug = Match(PKG4, MLT, Buffer(0x04){0, 1, 2, 4}, MTR, "", 0x0) // if(PKG4[i] < Buffer(0x04){0, 1, 2, 4} && true)

			//! expect: (integer 0x3)
			Debug = Match(PKG4, MGE, Buffer(0x04){0, 1, 2, 6}, MTR, "", 0x0) // if(PKG4[i] >= Buffer(0x04){0, 1, 2, 6} && true)
		}

		Method(_INI)
		{
			INT_()
			STR_()
			BUF_()
		}
	}
}
