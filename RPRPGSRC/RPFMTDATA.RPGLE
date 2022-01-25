     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPFMTDATA - Reformat data from AS/400 to EBCDIC text         *
      *                                                               *
      *  Function:  This module contains a number of procedures, one  *
      *             per data type to be converted.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. CRP004             Date 05Aug99               *
      *                 CRP003             Date 12Oct99               *
      *                 CRP002  *CREATE    Date 13Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  CRP004 - TransData and associated fields increased in length *
      *           by 2000 bytes in /COPY STD_DCL                      *
      *  CRP003 - Routine to format an entire record added            *
      *  CRP002 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT
                                                                                CRP003
      ** Declare the Message Format file.                                       CRP003
     FRPMSGFPD  IF   E           K DISK                                         CRP003

      * Following /COPY is the procedure prototype for the Packed routine
      /COPY RPCPYSRC,RPFMTPPP

      * Following /COPY is the procedure prototype for the Signed routine
      /COPY RPCPYSRC,RPFMTPPS
                                                                                CRP003
      * Following /COPY is the procedure prototype for the Format routine       CRP003
      /COPY RPCPYSRC,RPFMTPPF                                                   CRP003
                                                                                CRP003
      * Following /COPY is the declares for fields passed to the formatting     CRP003
      *  routines                                                               CRP003
     C/COPY RPCPYSRC,RPFMTDCL                                                   CRP003
                                                                                CRP003
      ** The following /COPY contains various standard declares                 CRP003
     C*COPY*RPCPYSRC,Std_Dcl                                                              CRP003 XX
     C/COPY RPCPYSRC,STD_DCL                                                              CRP003 XX
                                                                                CRP003
     D Defaults      E DS                  DTAARA(RPDFTSDA) EXTNAME(RPDFTSDA)   CRP003
                                                                                CRP003
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

      ** First time only, access the defaults data area                         CRP003
     C                   IF        FirstTimeDone = *BLANK
     C                   IN        Defaults                                     CRP003
     C                   EVAL      FirstTimeDone = 'Y'
     C                   ENDIF

      ** Place the incoming number into an alpha field for substringing
      **  purposes
     C                   movel     InNumber      InAlpha
                                                                                CRP003
      ** If Replication formatting is required (i.e. all numerics are           CRP003
      **  represented as two bytes longer than the number of digits in          CRP003
      **  all cases) then;                                                      CRP003
      **   If the number of decimal places is 0, increase the length            CRP003
      **    by 1 so that a leading zero is introduced.                          CRP003
                                                                                CRP003
     C                   If            RCZeroFld = '+2'                         CRP003
     C                             And DecPos = 0                               CRP003
     C                   Eval      Length = Length + 1                          CRP003
     C                   EndIf                                                  CRP003

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
      *****************************************************************         CRP003
      *    Procedure   : ProcFormat                                   *         CRP003
      *    Purpose     : Convert AS/400 format to EBCDIC text         *         CRP003
      *    Called by   : External routine                             *         CRP003
      *****************************************************************         CRP003
                                                                                CRP003
     P ProcFormat      B                   export                               CRP003
                                                                                CRP003
     D                 PI            +4          like(TransData)                CRP003
     D   InData                            value like(TransData)                CRP003
     D   InDBFile                    10A   value                                CRP003
     D   DecSep                       1A   value                                CRP003
     D   ShwPosSign                   1A   value                                CRP003
                                                                                CRP003
     DOutParms         DS                                                       CRP003
     D   OutData                           INZ(*BLANKS) like(TransData)         CRP003
     D   OutPos                       4S 0 INZ(1)                               CRP003
                                                                                CRP003
     DFmtInp           DS                                                       CRP003
     D FmtInp30A               1     30A                                        CRP003
     D FmtInp01P               1     01P 0                                      CRP003
     D FmtInp03P               1     02P 0                                      CRP003
     D FmtInp05P               1     03P 0                                      CRP003
     D FmtInp07P               1     04P 0                                      CRP003
     D FmtInp09P               1     05P 0                                      CRP003
     D FmtInp11P               1     06P 0                                      CRP003
     D FmtInp13P               1     07P 0                                      CRP003
     D FmtInp15P               1     08P 0                                      CRP003
     D FmtInp17P               1     09P 0                                      CRP003
     D FmtInp19P               1     10P 0                                      CRP003
     D FmtInp21P               1     11P 0                                      CRP003
     D FmtInp23P               1     12P 0                                      CRP003
     D FmtInp25P               1     13P 0                                      CRP003
     D FmtInp27P               1     14P 0                                      CRP003
     D FmtInp29P               1     15P 0                                      CRP003
     D FmtInp01S               1     01S 0                                      CRP003
     D FmtInp02S               1     02S 0                                      CRP003
     D FmtInp03S               1     03S 0                                      CRP003
     D FmtInp04S               1     04S 0                                      CRP003
     D FmtInp05S               1     05S 0                                      CRP003
     D FmtInp06S               1     06S 0                                      CRP003
     D FmtInp07S               1     07S 0                                      CRP003
     D FmtInp08S               1     08S 0                                      CRP003
     D FmtInp09S               1     09S 0                                      CRP003
     D FmtInp10S               1     10S 0                                      CRP003
     D FmtInp11S               1     11S 0                                      CRP003
     D FmtInp12S               1     12S 0                                      CRP003
     D FmtInp13S               1     13S 0                                      CRP003
     D FmtInp14S               1     14S 0                                      CRP003
     D FmtInp15S               1     15S 0                                      CRP003
     D FmtInp16S               1     16S 0                                      CRP003
     D FmtInp17S               1     17S 0                                      CRP003
     D FmtInp18S               1     18S 0                                      CRP003
     D FmtInp19S               1     19S 0                                      CRP003
     D FmtInp20S               1     20S 0                                      CRP003
     D FmtInp21S               1     21S 0                                      CRP003
     D FmtInp22S               1     22S 0                                      CRP003
     D FmtInp23S               1     23S 0                                      CRP003
     D FmtInp24S               1     24S 0                                      CRP003
     D FmtInp25S               1     25S 0                                      CRP003
     D FmtInp26S               1     26S 0                                      CRP003
     D FmtInp27S               1     27S 0                                      CRP003
     D FmtInp28S               1     28S 0                                      CRP003
     D FmtInp29S               1     29S 0                                      CRP003
     D FmtInp30S               1     30S 0                                      CRP003
                                                                                CRP003
     D fmPack3010      S             30P10                                      CRP003
     D fmAlpNum32      S             32A                                        CRP003
     D FmtResSize      S              4P 0                                      CRP003
     D FmtRes1000A     S           1000A                                        CRP003
                                                                                CRP003
     D WrkFactor       S             11P 0                                      CRP003
                                                                                CRP003
      ** Define Key List for PF/RPMSGFPD.                                       CRP003
     C     @KList01      KLIST                                                  CRP003
     C                   KFLD                    @KDBFile         10            CRP003
                                                                                CRP003
      * Set up the variables for formatting that will not change during the     CRP003
      *  run                                                                    CRP003
     C                   eval      fmDecSep   = DecSep                          CRP003
     C                   eval      fmShwPsSgn = ShwPosSign                      CRP003
                                                                                CRP003
     C                   RESET                   OutData                        CRP003
     C                   RESET                   OutPos                         CRP003
                                                                                CRP003
      ** Access first record for format requested.                              CRP003
     C                   Eval      @KDBFile = InDBFile                          CRP003
     C     @KList01      SETLL     RPMSGFPD                                     CRP003
     C     @KList01      READE     RPMSGFPD                               90    CRP003
                                                                                CRP003
      ** Process all fields on the format.                                      CRP003
     C     *IN90         DOWEQ     '0'                                          CRP003
                                                                                CRP003
      ** Select type of processing required.                                    CRP003
     C                   SELECT                                                 CRP003
     C     WHFLDT        WHENEQ    'P'                                          CRP003
     C                   EXSR      #SRPack                                      CRP003
     C     WHFLDT        WHENEQ    'S'                                          CRP003
     C                   EXSR      #SRSign                                      CRP003
     C                   OTHER                                                  CRP003
     C                   EXSR      #SRAlpha                                     CRP003
     C                   ENDSL                                                  CRP003
                                                                                CRP003
      ** Join up text to form output message.                                   CRP003
     C                   EVAL      %subst(OutData:OutPos:FmtResSize) =          CRP003
     C                               %subst(FmtRes1000A:1:FmtResSize)           CRP003
     C                   EVAL      OutPos = OutPos + FmtResSize                 CRP003
                                                                                CRP003
      ** Process next record                                                    CRP003
     C     @KList01      READE     RPMSGFPD                               90    CRP003
     C                   ENDDO                                                  CRP003
                                                                                CRP003
     C                   RETURN    OutParms                                     CRP003
                                                                                CRP003
      /EJECT                                                                    CRP003
      *****************************************************************         CRP003
      *                                                               *         CRP003
      * #SRPack - Process Packed Fields                               *         CRP003
      *           Called by process ProcFormat for each Packed field  *         CRP003
      *           on the format.                                      *         CRP003
      *                                                               *         CRP003
      *****************************************************************         CRP003
                                                                                CRP003
     C     #SRPack       BEGSR                                                  CRP003
                                                                                CRP003
      ** Obtain the field length and decimal places from the Message Format     CRP003
      **  file and then extract the right amount of data from the large         CRP003
      **  input field.                                                          CRP003
     C                   EVAL      fmLength = WHFLDD                            CRP003
     C                   EVAL      fmDecPos = WHFLDP                            CRP003
     C                   EVAL      FmtInp30A  = %Subst(InData:WHFOBO:WHFLDB)    CRP003
                                                                                CRP003
      ** FmtInp30A is 30 alpha, so the correct sub-set of bytes (as a           CRP003
      **  numeric field) needs to be used as the input parameter to the         CRP003
      **  reformatting routine (which expects numeric input)                    CRP003
     C                   SELECT                                                 CRP003
     C     WHFLDB        WHENEQ    01                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp01P                       CRP003
     C     WHFLDB        WHENEQ    02                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp03P                       CRP003
     C     WHFLDB        WHENEQ    03                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp05P                       CRP003
     C     WHFLDB        WHENEQ    04                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp07P                       CRP003
     C     WHFLDB        WHENEQ    05                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp09P                       CRP003
     C     WHFLDB        WHENEQ    06                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp11P                       CRP003
     C     WHFLDB        WHENEQ    07                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp13P                       CRP003
     C     WHFLDB        WHENEQ    08                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp15P                       CRP003
     C     WHFLDB        WHENEQ    09                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp17P                       CRP003
     C     WHFLDB        WHENEQ    10                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp19P                       CRP003
     C     WHFLDB        WHENEQ    11                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp21P                       CRP003
     C     WHFLDB        WHENEQ    12                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp23P                       CRP003
     C     WHFLDB        WHENEQ    13                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp25P                       CRP003
     C     WHFLDB        WHENEQ    14                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp27P                       CRP003
     C     WHFLDB        WHENEQ    15                                           CRP003
     C                   EVAL      fmPack3010 = FmtInp29P                       CRP003
     C                   OTHER                                                  CRP003
     C                   EVAL      fmPack3010 = 0                               CRP003
     C                   ENDSL                                                  CRP003
                                                                                CRP003
      ** Adjust input field for the number of decimal places.                   CRP003
      **  This is needed as the fields that are sub-sets of FmtInp30A all       CRP003
      **  have zero decimal places, so the value will all be in the part of     CRP003
      **  fmPack3010 that is to the left of the decimal point.  This action     CRP003
      **  will correctly align the data on the decimal point.                   CRP003
     C                   EVAL      WrkFactor   = 10**fmDecPos                   CRP003
     C                   EVAL      fmPack3010  = fmPack3010/WrkFactor           CRP003
                                                                                CRP003
      ** Reformat selected data to alpha                                        CRP003
     C                   EVAL      fmAlpNum32  = ProcPacked(fmPack3010:         CRP003
     C                                 fmLength:fmDecPos:fmDecSep:fmShwPsSgn)   CRP003
                                                                                CRP003
      ** Extract alpha equivalent into a common 1000 alpha field in which       CRP003
      **  it will go back to the caller                                         CRP003
     C                   EVAL      FmtResSize  = WHFLDD + 2                     CRP003
     C                   EVAL      FmtRes1000A =                                CRP003
     C                               %subst(fmAlpNum32:1:FmtResSize)            CRP003
                                                                                CRP003
     C                   ENDSR                                                  CRP003
                                                                                CRP003
      /EJECT                                                                    CRP003
      *****************************************************************         CRP003
      *                                                               *         CRP003
      * #SRSign - Process Signed Fields                               *         CRP003
      *           Called by process ProcFormat for each Signed field  *         CRP003
      *           on the format.                                      *         CRP003
      *                                                               *         CRP003
      *****************************************************************         CRP003
                                                                                CRP003
     C     #SRSign       BEGSR                                                  CRP003
                                                                                CRP003
      ** Obtain the field length and decimal places from the Message Format     CRP003
      **  file and then extract the right amount of data from the large         CRP003
      **  input field.                                                          CRP003
     C                   EVAL      fmLength = WHFLDD                            CRP003
     C                   EVAL      fmDecPos = WHFLDP                            CRP003
     C                   EVAL      FmtInp30A  = %Subst(InData:WHFOBO:WHFLDB)    CRP003
                                                                                CRP003
      ** FmtInp30A is 30 alpha, so the correct sub-set of bytes (as a           CRP003
      **  numeric field) needs to be used as the input parameter to the         CRP003
      **  reformatting routine (which expects numeric input)                    CRP003
     C                   SELECT                                                 CRP003
     C     WHFLDB        WHENEQ    01                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp01S                       CRP003
     C     WHFLDB        WHENEQ    02                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp02S                       CRP003
     C     WHFLDB        WHENEQ    03                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp03S                       CRP003
     C     WHFLDB        WHENEQ    04                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp04S                       CRP003
     C     WHFLDB        WHENEQ    05                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp05S                       CRP003
     C     WHFLDB        WHENEQ    06                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp06S                       CRP003
     C     WHFLDB        WHENEQ    07                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp07S                       CRP003
     C     WHFLDB        WHENEQ    08                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp08S                       CRP003
     C     WHFLDB        WHENEQ    09                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp09S                       CRP003
     C     WHFLDB        WHENEQ    10                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp10S                       CRP003
     C     WHFLDB        WHENEQ    11                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp11S                       CRP003
     C     WHFLDB        WHENEQ    12                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp12S                       CRP003
     C     WHFLDB        WHENEQ    13                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp13S                       CRP003
     C     WHFLDB        WHENEQ    14                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp14S                       CRP003
     C     WHFLDB        WHENEQ    15                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp15S                       CRP003
     C     WHFLDB        WHENEQ    16                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp16S                       CRP003
     C     WHFLDB        WHENEQ    17                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp17S                       CRP003
     C     WHFLDB        WHENEQ    18                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp18S                       CRP003
     C     WHFLDB        WHENEQ    19                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp19S                       CRP003
     C     WHFLDB        WHENEQ    20                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp20S                       CRP003
     C     WHFLDB        WHENEQ    21                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp21S                       CRP003
     C     WHFLDB        WHENEQ    22                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp22S                       CRP003
     C     WHFLDB        WHENEQ    23                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp23S                       CRP003
     C     WHFLDB        WHENEQ    24                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp24S                       CRP003
     C     WHFLDB        WHENEQ    25                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp25S                       CRP003
     C     WHFLDB        WHENEQ    26                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp26S                       CRP003
     C     WHFLDB        WHENEQ    27                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp27S                       CRP003
     C     WHFLDB        WHENEQ    28                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp28S                       CRP003
     C     WHFLDB        WHENEQ    29                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp29S                       CRP003
     C     WHFLDB        WHENEQ    30                                           CRP003
     C                   EVAL      fmSign3010 = FmtInp30S                       CRP003
     C                   OTHER                                                  CRP003
     C                   EVAL      fmPack3010 = 0                               CRP003
     C                   ENDSL                                                  CRP003
                                                                                CRP003
      ** Adjust input field for the number of decimal places.                   CRP003
      **  This is needed as the fields that are sub-sets of FmtInp30A all       CRP003
      **  have zero decimal places, so the value will all be in the part of     CRP003
      **  fmPack3010 that is to the left of the decimal point.  This action     CRP003
      **  will correctly align the data on the decimal point.                   CRP003
     C                   EVAL      WrkFactor   = 10**fmDecPos                   CRP003
     C                   EVAL      fmPack3010  = fmPack3010/WrkFactor           CRP003
                                                                                CRP003
      ** Reformat selected data to alpha                                        CRP003
     C                   EVAL      fmAlpNum32  = ProcSigned(fmSign3010:         CRP003
     C                               fmLength:fmDecPos:fmDecSep:fmShwPsSgn)     CRP003
                                                                                CRP003
      ** Extract alpha equivalent into a common 1000 alpha field in which       CRP003
      **  it will go back to the caller                                         CRP003
     C                   EVAL      FmtResSize  = WHFLDD + 2                     CRP003
     C                   EVAL      FmtRes1000A = %subst(fmAlpNum32:1:FmtResSize)CRP003
                                                                                CRP003
     C                   ENDSR                                                  CRP003
                                                                                CRP003
      /EJECT                                                                    CRP003
      *****************************************************************         CRP003
      *                                                               *         CRP003
      * #SRAlpha - Process AlphaNumeric Fields                        *         CRP003
      *            Called by process ProcFormat for each Alpha field  *         CRP003
      *            on the format.                                     *         CRP003
      *                                                               *         CRP003
      *****************************************************************         CRP003
                                                                                CRP003
     C     #SRAlpha      BEGSR                                                  CRP003
                                                                                CRP003
      ** Simply place into a common 1000 alpha field in which it will go        CRP003
      **  back to the caller                                                    CRP003
     C                   EVAL      FmtResSize  = WHFLDB                         CRP003
     C                   EVAL      FmtRes1000A= %Subst(InData:WHFOBO:WHFLDB)    CRP003
                                                                                CRP003
     C                   ENDSR                                                  CRP003
                                                                                CRP003
      ********************************************************************      CRP003
                                                                                CRP003
     P ProcFormat      E                                                        CRP003
