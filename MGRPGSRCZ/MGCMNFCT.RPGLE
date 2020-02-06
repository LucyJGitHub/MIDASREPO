     H DEBUG
     H NOMAIN
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS MG Common Functions')
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MGCMNFCT - Midas MG Common Functions.                        *
      *                                                               *
      *  Function:  This module contains common procedures used.      *
      *                                                               *
      *  Call by : MOD/MG000942  Format interim transaction message   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 14May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation.                           *
      *                                                               *
      *****************************************************************
 
     D MGMT94DA      E DS             6    EXTNAME(MGMT94DA)  DTAARA(MGMT94DA)
      ** Data Structure to retrieve the next message sequence.
 
     D RUNDAT        E DS            13    EXTNAME(RUNDAT)    DTAARA(RUNDAT)
      ** Data Structure to retrieve the next message sequence.
 
     D StartDate       S               D   DATFMT(*ISO) INZ(D'1971-12-31')
 
      **  MG Common Functions - Declaration
     D/COPY MGCPYSRC,MGCMNFCTDC
 
      *========================================================================*
      * #SWIFTDt : Convert Midas date to Swift Date.                           *
      *------------------------------------------------------------------------*
 
     P #SWIFTDt        B                   EXPORT
      *--------
 
     D #SWIFTDt        PI             6A                                        Date in SWIFT Format
     D  ZDAYNO                        5P 0 VALUE                                Date in Midas Format
 
     D  WKDate         S               D   DATFMT(*YMD)                         Date in Date format
     D  ZDATE          S              6S 0                                      Date in Numeric form
     D  ZDATEA         S              6A                                        Date in Alpha format
 
     C     StartDate     ADDDUR    ZDAYNO:*D     WkDate
     C     *YMD          MOVE      WkDate        ZDATE
     C                   MOVE      ZDATE         ZDATEA
 
     C                   RETURN    ZDATEA
      *--------
     P #SWIFTDt        E
 
      *========================================================================*
      * #SWIFTAm : Convert Midas Amount in SWIFT Amount.                       *
      *------------------------------------------------------------------------*
 
     P #SWIFTAm        B                   EXPORT
      *--------
 
     D #SWIFTAm        PI            15A                                        Amount SWIFT Format
     D  PSTA                         15P 0 VALUE                                Amount Midas Format
     D  NBDP                          1P 0 VALUE                                MIDAS Number of Deci
     D  SWDP                          1P 0 VALUE                                SWIFT Number of Deci
     D  CSW020                        1A   VALUE                                Feature CSW020
 
     D  WkSWIFTAmnt    S             15A                                        Amount SWIFT Format
 
     D                 DS
     D  WkAmnNum                     15S 0                                      Amount in Numerique
     D  WkAmnAlp                     15A   OVERLAY(WkAmnNum)                    Amount in Alpha.
 
     D  WkDecPos       S              1S 0                                      Number of decimal
     D  WkAmount       S             15S 0                                      Amount in Numerique
     D  WkDivisor      S              5U 0                                      Divisor
 
     D DsAmount        DS                                                       Amount
     D  WkInteger                    15A                                        Interger part
     D  WkComma                       1A   INZ(',')                             Comma
     D  WkDecimal                    15A                                        Decimal part
 
      ** Adjust the amount if the Swift decimal places differs from the currency decimal places
      ** and the feature CSW020 is installed.
 
     C                   IF        CSW020 = 'Y'
     C                             AND NBDP <> SWDP
     C                   EVAL      WkAmnNum = PSTA * 10 ** (SWDP - NBDP)
     C                   EVAL      WkDecPos = SWDP
 
      ** Otherwise
 
     C                   ELSE
     C                   EVAL      WkAmnNum = PSTA
     C                   EVAL      WkDecPos = NBDP
     C                   ENDIF
 
      ** Format the Interger Part.
 
     C                   EVAL      WkDivisor = 10 ** WkDecPos
     C                   EVAL      WkAmount  = %DIV(WkAmnNum:WkDivisor)
     C                   IF        WkAmount  <> *ZEROS
     C                   EVALR     WkInteger = %CHAR(WkAmount)
     C                   ELSE
     C                   EVALR     Wkinteger = '0'
     C                   ENDIF
 
      ** Format the Decimal Part.
 
     C                   IF        WkDecPos  <> *ZEROS
     C                   EVAL      WkDecimal = %SUBST(WkAmnAlp:
     C                                                15-WkDecPos+1:WkDecPos)
     C                   ELSE
     C                   EVAL      WkDecimal = *BLANKS
     C                   ENDIF
 
      ** Format the Amount.
 
     C                   EVAL      WkSWIFTAmnt = %TRIM(DsAmount)
 
     C                   RETURN    WKSWIFTAmnt
      *--------
     P #SWIFTAm        E
 
      *========================================================================*
      * #RtvTRNO : Retrieve the Transaction Reference.                         *
      *------------------------------------------------------------------------*
 
     P #RtvTRNO        B                   EXPORT
      *--------
 
     D #RtvTRNO        PI            16A                                        Trans. Reference Nb.
     D  ModID                         2A   VALUE                                Module ID
     D  TrnRef                       15A   VALUE                                Transaction Ref.
 
     D  WkTRNO         S             16A                                        Transaction Ref.
     D  WkSequence     S              6S 0                                      Sequence in Num.
     D  WkSeqAlpha     S              6A                                        Sequence in Alpha.
 
     C                   SELECT
     C                   WHEN      ModID = 'GL'
 
      **  Retrieve the message sequence.
      **    To avoid any confusion with other GL message generations,
      **    the sequence defined in 6 digits and never terminated by 00.
 
     C     *LOCK         IN        MGMT94DA
     C                   EVAL      WkSequence = MGSEQN + 1
     C                   EVAL      MGSEQN = WkSequence
     C                   OUT       MGMT94DA
     C                   MOVE      WkSequence    WkSeqAlpha
 
      **  Built the Transaction Reference.
 
     C                   EVAL      WkTRNO = ModID + %SUBST(TrnRef:1:6)
     C                                    + WkSeqAlpha
 
     C                   ENDSL
 
     C                   RETURN    WkTRNO
 
      *--------
     P #RtvTRNO        E
      *========================================================================*
      * #RtvACID : Retrieve the Account Identifier.                            *
      *------------------------------------------------------------------------*
 
      ** The Account Identifier is:
      **   - MT920 Account Identifier if exist,
      **   - else, the IBAN if exist,
      **   - else, the Retail Account if exist,
      **   - else, the Full Account with the branch if multi-branching environment,
 
     P #RtvACID        B                   EXPORT
      *--------
 
     D #RtvACID        PI            35A                                        Account Identifier
     D***ACCNT**                     18A   VALUE                                Full Account  CGL029
     D   ACCNT                       24A   VALUE                                Full Account  CGL029
     D   ACNO                        10S 0 VALUE                                Retail Account
     D   IBAN                        34A   VALUE                                IBAN
     D   MT920                       35A   VALUE                                MT920 Account Id
 
     D  WkAccIdent     S             35A                                        Account Identifier
 
     C                   SELECT
 
     C                   WHEN      MT920 <> *BLANKS                             MT920 Accnt Identif
     C                   EVAL      WkAccIdent = MT920
 
     C                   WHEN      IBAN  <> *BLANKS                             IBAN
     C                   EVAL      WkAccIdent = IBAN
 
     C                   WHEN      ACNO  <> *ZEROS                              Retail Number
     C                   MOVEL(P)  ACNO          WkAccIdent
 
     C                   OTHER                                                  Full Account
 
     C                   IN        RUNDAT
     C                   IF        AGMBIN <> 'Y'                                Mono-Branching
     C**********         EVAL      WkAccIdent = %SUBST(ACCNT:4:15)                            CGL029
     C                   EVAL      WkAccIdent = %SUBST(ACCNT:4:21)                            CGL029
     C                   ELSE                                                   Multi-Branching
     C                   EVAL      WkAccIdent = ACCNT
     C                   ENDIF
 
     C                   ENDSL
 
     C                   RETURN    WkAccIdent
 
      *--------
     P #RtvACID        E
      *========================================================================*
      * #RtvDtTm : Retrieve Date/Time Indication.                              *
      *------------------------------------------------------------------------*
 
     P #RtvDtTm        B                   EXPORT
      *--------
 
     D #RtvDtTm        PI            15A                                        Date/Time Indication
     D   W42LSD                       5P 0 VALUE                                Last statement date
     D   W42LST                       6P 0 VALUE                                Last statement time
     D   W8TMOF                       4S 0 VALUE                                Time Offset against
     D   W8SIGN                       1A   VALUE                                Time Offset Sign
     D   W8STOF                       4S 0 VALUE                                System Time Offset
     D   W8SSIN                       1A   VALUE                                System Time Offset S
 
     D WkDatTimId      S             15A                                        Date/Time Indication
 
     D WkDateTime      S               Z                                        Date/Time
     D WkStampChr      S             26A                                        Stamp in Character
     D WkHHMMSS        DS                                                       Time
     D   WkHH                         2S 0                                      Hours
     D   WkMM                         2S 0                                      Minutes
     D   WkSS                         2S 0                                      Seconds
 
      ** Compute the Time Stamp corresponding to message generation.
 
     C                   MOVEL     W42LST        WkHHMMSS
 
     C                   MOVE      StartDate     WkDateTime                     Date
     C                   ADDDUR    W42LSD:*D     WkDateTime                     Date
     C                   ADDDUR    WkHH  :*H     WkDateTime                     Hour
     C                   ADDDUR    WkMM  :*MN    WkDateTime                     Minute
 
      ** Add/Substract the System Offset
 
     C                   MOVEL     W8STOF        WkHHMMSS
 
     C                   IF        W8SSIN = '+'
     C                   ADDDUR    WkHH  :*H     WkDateTime                     Hour
     C                   ADDDUR    WkMM  :*MN    WkDateTime                     Minute
     C                   ELSE
     C                   SUBDUR    WkHH  :*H     WkDateTime                     Hour
     C                   SUBDUR    WkMM  :*MN    WkDateTime                     Minute
     C                   ENDIF
 
      ** Format Date/Time Indication
 
     C     *ISO0         MOVEL(P)  WkDateTime    WkStampChr                     Generation Date/Time
     C                   MOVEL     W8TMOF        WkHHMMSS                       Time Offset
 
     C                   EVAL      WkDatTimId = %SUBST(WkStampChr:3:10) +       YYMMDDHHMM
     C                                          W8SIGN +                        Time Offset Sign
     C                                          %SUBST(WkHHMMSS:1:4)            Time Offset
 
     C                   RETURN    WkDatTimId
 
      *--------
     P #RtvDtTm        E
      *--------------------------------------------------------------*
 
