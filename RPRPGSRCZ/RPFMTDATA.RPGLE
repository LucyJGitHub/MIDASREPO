     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Format data from AS/400->EBCDIC text')
      *****************************************************************
      *                                                               *
      *  Midas - Replication                                          *
      *                                                               *
      *  RPFMTDATA - Reformat Ddta From AS/400 to EBCDIC Text         *
      *                                                               *
      *  Function:  This module contains a number of procedures, one  *
      *             per data type to be converted.                    *
      *                                                               *
      *  Note: This member is a copy of a replication product member  *
      *        introduced to avoid the need for non-Replication       *
      *        systems to have the Replication libraries present.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK016  *CREATE    Date 22Apr03               *
      *                 XXXXXX             Date NNXxxNN               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK016 - Midas R5 packaging.                                 *
      *           - Break direct link with Replication product.       *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** Declare the Message Format file.
     FRPMSGFPD  IF   E           K DISK
 
      * Following /COPY is the procedure prototype for the Packed routine
      /COPY RPCPYSRC,RPFMTPPP
 
      * Following /COPY is the procedure prototype for the Signed routine
      /COPY RPCPYSRC,RPFMTPPS
 
      * Following /COPY is the procedure prototype for the Format routine
      /COPY RPCPYSRC,RPFMTPPF
 
      * Following /COPY is the declares for fields passed to the formatting
      *  routines
     C/COPY RPCPYSRC,RPFMTDCL
 
      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,Std_Dcl
 
     D Defaults      E DS                  DTAARA(RPDFTSDA) EXTNAME(RPDFTSDA)
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *    Procedure   : ProcPacked                                   *
      *    Purpose     : Convert AS/400 Packed to EBCDIC text         *
      *    Called by   : External routine                             *
      *****************************************************************
 
     P ProcPacked      B                   export
 
     D                 PI            32A
     D   InNumber                    30P10 value
     D   Length                       2S 0 value
     D   DecPos                       2S 0 value
     D   DecSep                       1A   value
     D   ShwPosSign                   1A   value
 
      * Following /COPY is the procedure prototype for the Signed routine
      /COPY RPCPYSRC,RPFMTPPS
 
      * Following /COPY is the declares for fields passed to the formatting
      *  routines
      /COPY RPCPYSRC,RPFMTDCL
 
     D  InAlpha        S             30A   INZ(*BLANKS)
     D  OutAlpha       S             32A   INZ(*BLANKS)
 
     C                   RESET                   OutAlpha
     C                   RESET                   InAlpha
 
      ** Convert the incoming number from packed to signed
     C                   eval      fmSign3010 = InNumber
 
      ** Set up the other parameters on the call to the Signed procedure as
      **  the incoming values
     C                   eval      fmLength   = Length
     C                   eval      fmDecPos   = DecPos
     C                   eval      fmDecSep   = DecSep
     C                   eval      fmShwPsSgn = ShwPosSign
 
      ** Use the Signed procedure to reformat the data to alpha
     C                   eval      OutAlpha =
     C                              ProcSigned(fmSign3010:fmLength:fmDecPos:
     C                                                 fmDecSep:fmShwPsSgn)
 
     C                   return    OutAlpha
 
     P ProcPacked      E
 
      /EJECT
      *****************************************************************
      *    Procedure   : ProcSigned                                   *
      *    Purpose     : Convert AS/400 Signed to EBCDIC text         *
      *    Called by   : External routine                             *
      *****************************************************************
 
     P ProcSigned      B                   export
 
     D                 PI            32A
     D   InNumber                    30S10 value
     D   Length                       2S 0 value
     D   DecPos                       2S 0 value
     D   DecSep                       1A   value
     D   ShwPosSign                   1A   value
 
     D  InAlpha        S             30A   INZ(*BLANKS)
     D  InPtr          S              2S 0 INZ(1)
     D  OutPtr         S              2S 0 INZ(1)
     D  OutAlpha       S             32A   INZ(*BLANKS)
 
     D  FirstTimeDone  S              1A   INZ(*BLANKS)
 
     C                   RESET                   InAlpha
     C                   RESET                   InPtr
     C                   RESET                   OutAlpha
     C                   RESET                   OutPtr
 
      ** First time only, access the defaults data area
     C                   IF        FirstTimeDone = *BLANK
     C                   IN        Defaults
     C                   EVAL      FirstTimeDone = 'Y'
     C                   ENDIF
 
      ** Place the incoming number into an alpha field for substringing
      **  purposes
     C                   movel     InNumber      InAlpha
 
      ** If Replication formatting is required (i.e. all numerics are
      **  represented as two bytes longer than the number of digits in
      **  all cases) then;
      **   If the number of decimal places is 0, increase the length
      **    by 1 so that a leading zero is introduced.
 
     C                   If            RCZeroFld = '+2'
     C                             And DecPos = 0
     C                   Eval      Length = Length + 1
     C                   EndIf
 
      ** Set the first byte of the Output field as the sign, only put in
      **  a positive sign if specifically requested.
     C                   if        InNumber < 0
     C                   eval      %subst(OutAlpha:OutPtr:1) = '-'
 
     C                   else
 
     C                   if        ShwPosSign = 'Y'
     C                   eval      %subst(OutAlpha:OutPtr:1) = '+'
     C                   endif
 
     C                   endif
 
     C                   eval      OutPtr = OutPtr + 1
 
      ** Extract the digits to the left of the decimal point
      ** As the whole number is aligned on the decimal point, and there are
      **  20 character to the left of the dp, this data will start at
      **  20 - N + 1, where N is the number digits to the left of the dp.
      **  N = Length - Decimal positions.
     C                   eval      InPtr = 20 - (Length-DecPos) + 1
     C                   eval      %subst(OutAlpha:OutPtr:(Length-DecPos)) =
     C                              %subst(InAlpha:InPtr:(Length-DecPos))
 
     C                   eval      InPtr = InPtr + (Length-DecPos)
     C                   eval      OutPtr = OutPtr + (Length-DecPos)
 
      ** If requested, insert a decimal separator and there are any decimals
     C                   if            DecSep <> *blank
     C                             and DecPos > 0
 
     C                   eval      %subst(OutAlpha:OutPtr:1) = DecSep
 
     C                   eval      OutPtr = OutPtr + 1
 
     C                   endif
 
      ** Extract the digits to the right of the decimal point if there are
      **  any
     C                   if        DecPos > 0
 
     C                   eval      %subst(OutAlpha:OutPtr:DecPos) =
     C                              %subst(InAlpha:InPtr:DecPos)
 
     C                   endif
 
     C                   return    OutAlpha
 
     P ProcSigned      E
 
      /EJECT
      *****************************************************************
      *    Procedure   : ProcFormat                                   *
      *    Purpose     : Convert AS/400 format to EBCDIC text         *
      *    Called by   : External routine                             *
      *****************************************************************
 
     P ProcFormat      B                   export
 
     D                 PI            +4          like(TransData)
     D   InData                            value like(TransData)
     D   InDBFile                    10A   value
     D   DecSep                       1A   value
     D   ShwPosSign                   1A   value
 
     DOutParms         DS
     D   OutData                           INZ(*BLANKS) like(TransData)
     D   OutPos                       4S 0 INZ(1)
 
     DFmtInp           DS
     D FmtInp30A               1     30A
     D FmtInp01P               1     01P 0
     D FmtInp03P               1     02P 0
     D FmtInp05P               1     03P 0
     D FmtInp07P               1     04P 0
     D FmtInp09P               1     05P 0
     D FmtInp11P               1     06P 0
     D FmtInp13P               1     07P 0
     D FmtInp15P               1     08P 0
     D FmtInp17P               1     09P 0
     D FmtInp19P               1     10P 0
     D FmtInp21P               1     11P 0
     D FmtInp23P               1     12P 0
     D FmtInp25P               1     13P 0
     D FmtInp27P               1     14P 0
     D FmtInp29P               1     15P 0
     D FmtInp01S               1     01S 0
     D FmtInp02S               1     02S 0
     D FmtInp03S               1     03S 0
     D FmtInp04S               1     04S 0
     D FmtInp05S               1     05S 0
     D FmtInp06S               1     06S 0
     D FmtInp07S               1     07S 0
     D FmtInp08S               1     08S 0
     D FmtInp09S               1     09S 0
     D FmtInp10S               1     10S 0
     D FmtInp11S               1     11S 0
     D FmtInp12S               1     12S 0
     D FmtInp13S               1     13S 0
     D FmtInp14S               1     14S 0
     D FmtInp15S               1     15S 0
     D FmtInp16S               1     16S 0
     D FmtInp17S               1     17S 0
     D FmtInp18S               1     18S 0
     D FmtInp19S               1     19S 0
     D FmtInp20S               1     20S 0
     D FmtInp21S               1     21S 0
     D FmtInp22S               1     22S 0
     D FmtInp23S               1     23S 0
     D FmtInp24S               1     24S 0
     D FmtInp25S               1     25S 0
     D FmtInp26S               1     26S 0
     D FmtInp27S               1     27S 0
     D FmtInp28S               1     28S 0
     D FmtInp29S               1     29S 0
     D FmtInp30S               1     30S 0
 
     D fmPack3010      S             30P10
     D fmAlpNum32      S             32A
     D FmtResSize      S              4P 0
     D FmtRes1000A     S           1000A
 
     D WrkFactor       S             11P 0
 
      ** Define Key List for PF/RPMSGFPD.
     C     @KList01      KLIST
     C                   KFLD                    @KDBFile         10
 
      * Set up the variables for formatting that will not change during the
      *  run
     C                   eval      fmDecSep   = DecSep
     C                   eval      fmShwPsSgn = ShwPosSign
 
     C                   RESET                   OutData
     C                   RESET                   OutPos
 
      ** Access first record for format requested.
     C                   Eval      @KDBFile = InDBFile
     C     @KList01      SETLL     RPMSGFPD
     C     @KList01      READE     RPMSGFPD                               90
 
      ** Process all fields on the format.
     C     *IN90         DOWEQ     '0'
 
      ** Select type of processing required.
     C                   SELECT
     C     WHFLDT        WHENEQ    'P'
     C                   EXSR      #SRPack
     C     WHFLDT        WHENEQ    'S'
     C                   EXSR      #SRSign
     C                   OTHER
     C                   EXSR      #SRAlpha
     C                   ENDSL
 
      ** Join up text to form output message.
     C                   EVAL      %subst(OutData:OutPos:FmtResSize) =
     C                               %subst(FmtRes1000A:1:FmtResSize)
     C                   EVAL      OutPos = OutPos + FmtResSize
 
      ** Process next record
     C     @KList01      READE     RPMSGFPD                               90
     C                   ENDDO
 
     C                   RETURN    OutParms
 
      /EJECT
      *****************************************************************
      *                                                               *
      * #SRPack - Process Packed Fields                               *
      *           Called by process ProcFormat for each Packed field  *
      *           on the format.                                      *
      *                                                               *
      *****************************************************************
 
     C     #SRPack       BEGSR
 
      ** Obtain the field length and decimal places from the Message Format
      **  file and then extract the right amount of data from the large
      **  input field.
     C                   EVAL      fmLength = WHFLDD
     C                   EVAL      fmDecPos = WHFLDP
     C                   EVAL      FmtInp30A  = %Subst(InData:WHFOBO:WHFLDB)
 
      ** FmtInp30A is 30 alpha, so the correct sub-set of bytes (as a
      **  numeric field) needs to be used as the input parameter to the
      **  reformatting routine (which expects numeric input)
     C                   SELECT
     C     WHFLDB        WHENEQ    01
     C                   EVAL      fmPack3010 = FmtInp01P
     C     WHFLDB        WHENEQ    02
     C                   EVAL      fmPack3010 = FmtInp03P
     C     WHFLDB        WHENEQ    03
     C                   EVAL      fmPack3010 = FmtInp05P
     C     WHFLDB        WHENEQ    04
     C                   EVAL      fmPack3010 = FmtInp07P
     C     WHFLDB        WHENEQ    05
     C                   EVAL      fmPack3010 = FmtInp09P
     C     WHFLDB        WHENEQ    06
     C                   EVAL      fmPack3010 = FmtInp11P
     C     WHFLDB        WHENEQ    07
     C                   EVAL      fmPack3010 = FmtInp13P
     C     WHFLDB        WHENEQ    08
     C                   EVAL      fmPack3010 = FmtInp15P
     C     WHFLDB        WHENEQ    09
     C                   EVAL      fmPack3010 = FmtInp17P
     C     WHFLDB        WHENEQ    10
     C                   EVAL      fmPack3010 = FmtInp19P
     C     WHFLDB        WHENEQ    11
     C                   EVAL      fmPack3010 = FmtInp21P
     C     WHFLDB        WHENEQ    12
     C                   EVAL      fmPack3010 = FmtInp23P
     C     WHFLDB        WHENEQ    13
     C                   EVAL      fmPack3010 = FmtInp25P
     C     WHFLDB        WHENEQ    14
     C                   EVAL      fmPack3010 = FmtInp27P
     C     WHFLDB        WHENEQ    15
     C                   EVAL      fmPack3010 = FmtInp29P
     C                   OTHER
     C                   EVAL      fmPack3010 = 0
     C                   ENDSL
 
      ** Adjust input field for the number of decimal places.
      **  This is needed as the fields that are sub-sets of FmtInp30A all
      **  have zero decimal places, so the value will all be in the part of
      **  fmPack3010 that is to the left of the decimal point.  This action
      **  will correctly align the data on the decimal point.
     C                   EVAL      WrkFactor   = 10**fmDecPos
     C                   EVAL      fmPack3010  = fmPack3010/WrkFactor
 
      ** Reformat selected data to alpha
     C                   EVAL      fmAlpNum32  = ProcPacked(fmPack3010:
     C                                 fmLength:fmDecPos:fmDecSep:fmShwPsSgn)
 
      ** Extract alpha equivalent into a common 1000 alpha field in which
      **  it will go back to the caller
     C                   EVAL      FmtResSize  = WHFLDD + 2
     C                   EVAL      FmtRes1000A =
     C                               %subst(fmAlpNum32:1:FmtResSize)
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * #SRSign - Process Signed Fields                               *
      *           Called by process ProcFormat for each Signed field  *
      *           on the format.                                      *
      *                                                               *
      *****************************************************************
 
     C     #SRSign       BEGSR
 
      ** Obtain the field length and decimal places from the Message Format
      **  file and then extract the right amount of data from the large
      **  input field.
     C                   EVAL      fmLength = WHFLDD
     C                   EVAL      fmDecPos = WHFLDP
     C                   EVAL      FmtInp30A  = %Subst(InData:WHFOBO:WHFLDB)
 
      ** FmtInp30A is 30 alpha, so the correct sub-set of bytes (as a
      **  numeric field) needs to be used as the input parameter to the
      **  reformatting routine (which expects numeric input)
     C                   SELECT
     C     WHFLDB        WHENEQ    01
     C                   EVAL      fmSign3010 = FmtInp01S
     C     WHFLDB        WHENEQ    02
     C                   EVAL      fmSign3010 = FmtInp02S
     C     WHFLDB        WHENEQ    03
     C                   EVAL      fmSign3010 = FmtInp03S
     C     WHFLDB        WHENEQ    04
     C                   EVAL      fmSign3010 = FmtInp04S
     C     WHFLDB        WHENEQ    05
     C                   EVAL      fmSign3010 = FmtInp05S
     C     WHFLDB        WHENEQ    06
     C                   EVAL      fmSign3010 = FmtInp06S
     C     WHFLDB        WHENEQ    07
     C                   EVAL      fmSign3010 = FmtInp07S
     C     WHFLDB        WHENEQ    08
     C                   EVAL      fmSign3010 = FmtInp08S
     C     WHFLDB        WHENEQ    09
     C                   EVAL      fmSign3010 = FmtInp09S
     C     WHFLDB        WHENEQ    10
     C                   EVAL      fmSign3010 = FmtInp10S
     C     WHFLDB        WHENEQ    11
     C                   EVAL      fmSign3010 = FmtInp11S
     C     WHFLDB        WHENEQ    12
     C                   EVAL      fmSign3010 = FmtInp12S
     C     WHFLDB        WHENEQ    13
     C                   EVAL      fmSign3010 = FmtInp13S
     C     WHFLDB        WHENEQ    14
     C                   EVAL      fmSign3010 = FmtInp14S
     C     WHFLDB        WHENEQ    15
     C                   EVAL      fmSign3010 = FmtInp15S
     C     WHFLDB        WHENEQ    16
     C                   EVAL      fmSign3010 = FmtInp16S
     C     WHFLDB        WHENEQ    17
     C                   EVAL      fmSign3010 = FmtInp17S
     C     WHFLDB        WHENEQ    18
     C                   EVAL      fmSign3010 = FmtInp18S
     C     WHFLDB        WHENEQ    19
     C                   EVAL      fmSign3010 = FmtInp19S
     C     WHFLDB        WHENEQ    20
     C                   EVAL      fmSign3010 = FmtInp20S
     C     WHFLDB        WHENEQ    21
     C                   EVAL      fmSign3010 = FmtInp21S
     C     WHFLDB        WHENEQ    22
     C                   EVAL      fmSign3010 = FmtInp22S
     C     WHFLDB        WHENEQ    23
     C                   EVAL      fmSign3010 = FmtInp23S
     C     WHFLDB        WHENEQ    24
     C                   EVAL      fmSign3010 = FmtInp24S
     C     WHFLDB        WHENEQ    25
     C                   EVAL      fmSign3010 = FmtInp25S
     C     WHFLDB        WHENEQ    26
     C                   EVAL      fmSign3010 = FmtInp26S
     C     WHFLDB        WHENEQ    27
     C                   EVAL      fmSign3010 = FmtInp27S
     C     WHFLDB        WHENEQ    28
     C                   EVAL      fmSign3010 = FmtInp28S
     C     WHFLDB        WHENEQ    29
     C                   EVAL      fmSign3010 = FmtInp29S
     C     WHFLDB        WHENEQ    30
     C                   EVAL      fmSign3010 = FmtInp30S
     C                   OTHER
     C                   EVAL      fmPack3010 = 0
     C                   ENDSL
 
      ** Adjust input field for the number of decimal places.
      **  This is needed as the fields that are sub-sets of FmtInp30A all
      **  have zero decimal places, so the value will all be in the part of
      **  fmPack3010 that is to the left of the decimal point.  This action
      **  will correctly align the data on the decimal point.
     C                   EVAL      WrkFactor   = 10**fmDecPos
     C                   EVAL      fmPack3010  = fmPack3010/WrkFactor
 
      ** Reformat selected data to alpha
     C                   EVAL      fmAlpNum32  = ProcSigned(fmSign3010:
     C                               fmLength:fmDecPos:fmDecSep:fmShwPsSgn)
 
      ** Extract alpha equivalent into a common 1000 alpha field in which
      **  it will go back to the caller
     C                   EVAL      FmtResSize  = WHFLDD + 2
     C                   EVAL      FmtRes1000A = %subst(fmAlpNum32:1:FmtResSize)
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * #SRAlpha - Process AlphaNumeric Fields                        *
      *            Called by process ProcFormat for each Alpha field  *
      *            on the format.                                     *
      *                                                               *
      *****************************************************************
 
     C     #SRAlpha      BEGSR
 
      ** Simply place into a common 1000 alpha field in which it will go
      **  back to the caller
     C                   EVAL      FmtResSize  = WHFLDB
     C                   EVAL      FmtRes1000A= %Subst(InData:WHFOBO:WHFLDB)
 
     C                   ENDSR
 
      ********************************************************************
 
     P ProcFormat      E
