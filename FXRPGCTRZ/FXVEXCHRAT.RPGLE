     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate exchange rate, fwd points & sign')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVEXCHRAT - Validate Exchange Rate, Fwd Points & Sign       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039203           Date 14Jun16               *
      *                 MD038850           Date 16May16               *
      *                 AR720772           Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23050A          Date 11Mar09               *
      *                 BUG23101           Date 26Feb09               *
      *                 BUG22009           Date 25Jan09               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248269             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG5578            Date 21Feb05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      *                 196952             Date 06May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154453             Date 04Nov98               *
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039203 - When creating an FX Deal, the value of Forward    *
      *             points and sign were not save upon completion of  *
      *             the transaction                                   *
      *  MD038850 - Initialize DDFPNT field.                          *
      *  AR720772 - Reverse fix BUG5578 to accept OT deal exchange    *
      *             rate not equal to related OP deal.                *
      *             (Child: AR720773)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23050A- Reciprocal indicator being defaulted.             *
      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
      *  BUG23101 - Midas error occurred for Incorrect Format in      *
      *             Exchange Rate field                               *
      *  BUG22009 - Reciprocal rate not accepted in FXDL type Option  *
      *             Takedown.                                         *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  BUG5578- Default and validate exchange rate for OT deals.    *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  196952 - Ensure Rate has 5 digits before decimal separator   *
      *           and 8 digits after. Use DDRAT1 instead of DDRATE.   *
      *  154453 - Apply fix 129183                                    *
      *         - Exchange rate with 5 digits not accepted            *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
                                                                                              154453
     D @@ALPH          DS                                                                     154453
     D  WPos14                 3      3                                                       154453
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.                                                       CER043
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CER043
                                                                                              CER043
      ** Array of warning message IDs                                                         CER043
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CER043
                                                                                              CER043
      ** Array of warning message data.                                                       CER043
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CER043
 
      ** Scaling factors
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
                                                                                              CER043
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
      ** EXTERNAL DS FOR SAR DETAILS                                                          CER043
                                                                                              CER043
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CER043
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     CER043
                                                                                              CER043
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                    CER043
                                                                                              CER043
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER043
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                    CER043
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)
      *****Ensure*OT*dela*rate*is*unpacked*for*passing*from*FXFXDLVAL**             BUG5578 AR720772
     D*****RelDXRT     S             13S 8                                          BUG5578 AR720772
     D     RelOSRT     S             13S 8                                                    248269
 
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CER043
      ** Index for arrays of of warning message ids etc                                       CER043
     D WIdx            S              3P 0                                                    CER043
                                                                                              CER043
     D CER043          S              1A                                                      CER043
     D DDREIN          S              1A                                                      CER043
     D PRtcd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PSard           S              6A                                                      CER043
     D WRetp           S              5S 2                                                    CER043
     D WSysExchrt      S             13P 8                                                    CER043
     D WNorExchrt      S             13P 8                                                    CER043
     D WDiff           S             13P 8                                                    CER043
     D WDeviatn        S             13P 8                                                    CER043
     D WExchRate       S             15P 8                                                  BUG22009
     D POutMDin        S              1A                                                      CER043
     D WCcy            S                   LIKE(A6CYCD)                                       CER043
                                                                                              CER043
     D DSWRK           DS                                                                     CER043
     D  WRK1                          3A                                                      CER043
     D  WRK2                          3A                                                      CER043
     D  WRK3                         15A                                                      CER043
     D  WRK4                          7A                                                      CER043
     D  WRK5                          3A                                                      CER043
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
                                                                                              CER043
     C                   EVAL      WFldNmXAr = *BLANKS                                        CER043
     C                   EVAL      WMsgIDXAr = *BLANKS                                        CER043
     C                   EVAL      WMsgDtXAr = *BLANKS                                        CER043
     C                   EVAL      WIdx = *ZEROS                                              CER043
     C                   EVAL      WRetp = *ZEROS                                             CER043
 
      *
      * RATEV  - RATE VALIDATION
      *
     C                   EXSR      RATEV
      *
      * FPNTV  - FORWARD POINT VALIDATION
      *
     C                   EXSR      FPNTV
      *
      * SIGNV  - FORWARD POINT SIGN VALIDATION
      *
     C                   EXSR      SIGNV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDRateOK      IFEQ      'N'
     C     DDFpntOK      OREQ      'N'
     C     DDSignOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RATEV  - RATE VALIDATION                                      *
      *****************************************************************
     C     RATEV         BEGSR
      **********                                                                    BUG5578 AR720772
      **If*this*is*an*Option*Takedown*should*default*in*the*rate*from**             BUG5578 AR720772
      **********                                                                    BUG5578 AR720772
     C*****DDDLTP        IFEQ      'OT'                                             BUG5578 AR720772
     C     S01453        IFEQ      'Y'                                                        248269
     C**********         MOVE      RelOSRT       @@AMTW                                     AR720772
     C                   MOVE      RelOSRT       @@AMTW           13 0                      AR720772
     C                   ELSE                                                                 248269
     C**********         MOVE      RelDXRT       @@AMTW                I:Amount     BUG5578 AR720772
     C                   ENDIF                                                                248269
     C**********         Z-ADD     8             @@QECN                I:Dec.places BUG5578 AR720772
     C**********         EXSR      ZA0920                              <Convert>    BUG5578 AR720772
     C**********         MOVE      @@AMTD        DDRATOD          14   O:To msg.dataBUG5578 AR720772
      **Only*default*if*field*has*not*already*been*entered.************             BUG5578 AR720772
      **Blank*is*already*formatted*as*'0*************'.****************             BUG5578 AR720772
      **********                                                                    BUG5578 AR720772
     C**********         MOVE      *BLANKS       DDRATBLK         14                BUG5578 AR720772
     C**********         MOVEL     '0'           DDRATBLK                           BUG5578 AR720772
     C*****DDRAT1        IFEQ      DDRATBLK                                         BUG5578 AR720772
     C*****DDRAT1        OREQ      *BLANKS                                          BUG5578 AR720772
     C**********         MOVE      DDRATOD       DDRAT1                             BUG5578 AR720772
     C**********         IF        CER043 = 'Y' and DDREIN = 'Y'                  BUG22009 BUG23050A
     C                   IF        CER043 = 'Y'                                   BUG22009 BUG23050A
     C                             and (DDDLTP = 'OT' or                                    MD039203
     C                                  DDDLTP = 'OP')                                      MD039203
     C**********         EVAL      DDFPNT = '0.00'                                BUG23050A MD038850
     C                   EVAL      DDFPNT = '0'                                             MD038850
     C                   EVAL      DDREIN = 'N'                                             BUG22009
     C                   ENDIF                                                              BUG22009
     C**********         ELSE                                                       BUG5578 AR720772
     C                   IF        CER043 = 'N'                                            BUG23050A
      **Accept*only*if*entered*rate*is*exactly*what*is*on*the*option*d*             BUG5578 AR720772
      **Here*DDRAT1*has*been*left*adjusted*by*the*framework,*DDRATOD*i*             BUG5578 AR720772
      **by*ZA0920.*So*compare*numeric*equivalents*instead.*************             BUG5578 AR720772
     C**********         Z-ADD     8             @@IDP                              BUG5578 AR720772
     C**********         Z-ADD     5             @@IINT                             BUG5578 AR720772
     C**********         MOVE      *BLANKS       @@ALPH                             BUG5578 AR720772
     C**********         MOVE      DDRAT1        @@ALPH                             BUG5578 AR720772
     C**********         MOVE      'N'           @@MTID                             BUG5578 AR720772
     C**********         EXSR      ZA0840                                           BUG5578 AR720772
     C**********         Z-ADD     @@AMT         SCRNAMT          15 0              BUG5578 AR720772
     C**********         IF        CER043 = 'Y' and DDREIN = 'Y'                  BUG22009 BUG23050A
     C**********         EVAL      WExchRate =  %DEC(DDRAT1:15:8)                 BUG22009 BUG23050A
     C**********         EVAL(H)   WExchRate =   1 / WExchRate                    BUG22009 BUG23050A
     C**********         MOVEL     WExchRate     SCRNAMT                          BUG22009 BUG23050A
     C**********         ENDIF                                                    BUG22009 BUG23050A
      **********                                                                    BUG5578 AR720772
     C**********         MOVE      *BLANKS       @@ALPH                             BUG5578 AR720772
     C**********         MOVE      DDRATOD       @@ALPH                             BUG5578 AR720772
     C**********         MOVE      'N'           @@MTID                             BUG5578 AR720772
     C**********         EXSR      ZA0840                                           BUG5578 AR720772
     C**********         Z-ADD     @@AMT         OPDLAMT          15 0              BUG5578 AR720772
      **********                                                                    BUG5578 AR720772
     C*****SCRNAMT       IFNE      OPDLAMT                                          BUG5578 AR720772
     C**********         MOVE      'N'           DDRateOK                           BUG5578 AR720772
     C**********         ADD       1             Idx                                BUG5578 AR720772
     C**********         MOVEL     'DDRAT1'      FldNamXAr(Idx)                     BUG5578 AR720772
     C**********         MOVEL     'FXM0140'     MsgIdXAr(Idx)                      BUG5578 AR720772
     C**********         END                                                        BUG5578 AR720772
     C                   ENDIF                                                             BUG23050A
     C**********         ENDIF                                                      BUG5578 AR720772
     C**********         ENDIF                                                      BUG5578 AR720772
      *
      * Rate must not be blank
      *
     C*****DDRATE        IFEQ      *BLANKS                                                    196952
     C     DDRAT1        IFEQ      *BLANKS                                                    196952
     C                   MOVE      'N'           DDRateOK
     C                   ADD       1             Idx
     C**********         MOVEL     'DDRATE'      FldNamXAr(Idx)                               196952
     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                               196952
     C                   MOVEL     'FXM0153'     MsgIdXAr(Idx)
     C                   END
      **********                                                                     CER043 BUG23101
      ***Determine*the*reciprocal*rate*tolerance*percentage                          CER043 BUG23101
      **********                                                                     CER043 BUG23101
     C**********         IF        CER043 = 'Y'                                      CER043 BUG23101
     C**********                   AND DDRateOK = 'Y'                                CER043 BUG23101
      **********                                                                     CER043 BUG23101
      **********                                                                     CER043 BUG23101
      ***Compute*for*the*reciprocal*rate*tolerance*percentage                        CER043 BUG23101
      **********                                                                     CER043 BUG23101
     C**********         EXSR      ZRECPRT                                           CER043 BUG23101
      **********                                                                     CER043 BUG23101
     C**********         ENDIF                                                       CER043 BUG23101
      *
      * Convert exchange rate into amount
      *
     C     DDRateOK      IFEQ      'Y'
     C     DDBCCY        IFEQ      BNCYDL
     C     DDBccyOK      ANDEQ     'Y'
     C     8             SUB       @@SXP2        @@IDP
     C*****12            SUB       @@IDP         @@IINT                         154453
     C     13            SUB       @@IDP         @@IINT                         154453
     C                   ELSE
     C     DDSCCY        IFEQ      BNCYDL
     C     DDSccyOK      ANDEQ     'Y'
     C     8             SUB       @@SXP1        @@IDP
     C*****12            SUB       @@IDP         @@IINT                         154453
     C     13            SUB       @@IDP         @@IINT                         154453
     C                   ELSE
     C                   Z-ADD     8             @@IDP
     C*****              Z-ADD     4             @@IINT                         154453
     C                   Z-ADD     5             @@IINT                         154453
     C                   END
     C                   END
     C                   MOVE      *BLANKS       @@ALPH
     C**********         MOVE      DDRATE        @@ALPH                                       196952
     C                   MOVE      DDRAT1        @@ALPH                                       196952
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
      * error
     C     @@ERCD        IFNE      0
     C     @@AMT         OREQ      *ZEROS
     C                   MOVE      'N'           DDRateOK
     C                   ADD       1             Idx
     C**********         MOVEL     'DDRATE'      FldNamXAr(Idx)                               196952
     C                   MOVEL     'DDRAT1'      FldNamXAr(Idx)                               196952
     C                   MOVEL     'FXM0150'     MsgIdXAr(Idx)
     C                   ELSE
      **********                                                                  BUG23101 BUG23050A
      ***Determine the reciprocal rate tolerance percentage                       BUG23101 BUG23050A
      **********                                                                  BUG23101 BUG23050A
     C**********         IF        CER043 = 'Y'                                   BUG23101 BUG23050A
     C**********                   AND DDRateOK = 'Y'                             BUG23101 BUG23050A
      **********                                                                  BUG23101 BUG23050A
      ***Compute for the reciprocal rate tolerance percentage                     BUG23101 BUG23050A
      **********                                                                  BUG23101 BUG23050A
     C**********         EXSR      ZRECPRT                                        BUG23101 BUG23050A
      **********                                                                  BUG23101 BUG23050A
     C**********         ENDIF                                                    BUG23101 BUG23050A
      *                                                                                       154453
      * If the full five integers are being used, drop the last                               154453
      * decimal place                                                                         154453
      *                                                                                       154453
     C     WPOS14        IFEQ      *BLANK                                                     154453
     C**********         MOVE      @@ALPH        DDRATE                                       196952
     C                   MOVE      @@ALPH        DDRAT1                                       196952
     C                   ELSE                                                                 154453
     C                   MOVE      @@ALPH        DDRAT14          14                          154453
     C**********         MOVEL     DDRAT14       DDRATE                                154453 196952
     C                   MOVEL     DDRAT14       DDRAT1                                       196952
     C                   END                                                                  154453
     C                   END
     C                   END
      *
      * Unscale the rate for output
      * (as the user input rate will be scaled)
      *
     C     DDRateOK      IFEQ      'Y'
     C     @@IDP         ADD       1             X1                5 0
     C     @@AMT         DIV       @SF(X1)       W@INRT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * FPNTV  - FORWARD POINT VALIDATION                             *
      *****************************************************************
     C     FPNTV         BEGSR
      *
      * Forward points must be a valid number
      *
     C                   Z-ADD     2             @@IDP
     C                   Z-ADD     5             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDFPNT        @@ALPH
     C                   MOVE      'N'           @@MTID
     C                   EXSR      ZA0840
      * error
     C     @@ERCD        IFNE      0
     C                   MOVE      'N'           DDFpntOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFPNT'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0151'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVE      @@ALPH        DDFPNT
     C                   END
      *
      * Forward points for output (It will be signed in sub. SIGNV)
      *
     C     DDFpntOK      IFEQ      'Y'
     C     @@AMT         DIV       100           F3FWPZ
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SIGNV  - FORWARD POINT SIGN VALIDATION                        *
      *****************************************************************
     C     SIGNV         BEGSR
      *
      * Default sign if not defined
      *
     C     DDSIGN        IFEQ      ' '
     C                   MOVE      '+'           DDSIGN
     C                   END
      *
      * Sign must be + or -
      *
     C     DDSIGN        IFNE      '+'
     C     DDSIGN        ANDNE     '-'
     C                   MOVE      'N'           DDSignOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDSIGN'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0173'     MsgIdXAr(Idx)
     C                   END
      *
      * Sign forward points according to sign
      * (sign is not stored on file)
      *
     C     DDSignOK      IFEQ      'Y'
     C     DDFpntOK      ANDEQ     'Y'
      *
     C     DDSIGN        IFEQ      '+'
     C                   Z-ADD     F3FWPZ        F3FWPZ
     C                   ELSE
     C                   Z-SUB     F3FWPZ        F3FWPZ
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE AN AMOUNT IN AN ALPHA FIELD & CONVERT TO NUM*
      *****************************************************************
     C     ZA0840        BEGSR
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH           16            Display field
     C                   PARM                    @@IDP             3 0          no.of dec.plcs
     C                   PARM                    @@IINT            3 0          no.of integers
     C                   PARM                    @@MTID            1            Million/Thous.
     C                   PARM      *ZERO         @@ERCD            1 0          Error code
     C                   PARM      *ZERO         @@AMT            15 0          File field
     C                   PARM                    BNDCSP
     C                   ENDSR
      *****************************************************************
      /EJECT
      ***********                                                                   BUG5578 AR720772
      **ZA0920*-*EDIT*AN*AMOUNT*INTO*AN*ALPHA*FIELD********************             BUG5578 AR720772
      ***********                                                                   BUG5578 AR720772
     C*****ZA0920        BEGSR                                                      BUG5578 AR720772
     C**********         CALLB     'ZA0920'                                         BUG5578 AR720772
     C**********         PARM      *BLANK        RetCodeOut                         BUG5578 AR720772
     C**********         PARM                    @@AMTW           13 0              BUG5578 AR720772
     C**********         PARM                    @@QECN            1 0              BUG5578 AR720772
     C**********         PARM                    BNDCSP                             BUG5578 AR720772
     C**********         PARM      *BLANK        @@AMTD           14                BUG5578 AR720772
     C**********         ENDSR                                                      BUG5578 AR720772
      **********                                                                    BUG5578 AR720772
      *********/EJECT                                                               BUG5578 AR720772
      *****************************************************************                       CER043
      *                                                               *                       CER043
      * ZRECPRT - Compute for reciprocal rate tolerance percentage    *                       CER043
      *                                                               *                       CER043
      *  Called by: RATEV                                             *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C*****ZRECPRT       BEGSR                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      ****Get*System exchange rate                                                  CER043 BUG23050A
     C**********         EVAL      WSysExchrt = *ZEROS                              CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         IF        @SPOT1 <> *ZEROS and @SPOT2 <> *ZEROS            CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      ***Mult./divide ind. the same                                                 CER043 BUG23050A
     C**********         IF        @@MDF1 = @@MDF2                                  CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      **If*both multiply calc. is rate1/rate2.                                      CER043 BUG23050A
      **If*both divide calc. is rate2/rate1.                                        CER043 BUG23050A
     C**********         IF        @@MDF1 = 'M'                                     CER043 BUG23050A
     C**********         EVAL(H)   WSysExchrt = @SPOT1 / @SPOT2                     CER043 BUG23050A
     C**********         ELSE                                                       CER043 BUG23050A
     C**********         EVAL(H)   WSysExchrt = @SPOT2 / @SPOT1                     CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      **Mult./divide ind. not the same                                              CER043 BUG23050A
     C**********         ELSE                                                       CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      **If*rate1 is mult. & rate2 is divide calc. is rate1 x rate2.                 CER043 BUG23050A
      **If*rate1 is divide & rate2 is mult. calc. is 1/(rate1 x rate2).             CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         IF        @@MDF1 = 'M'                                     CER043 BUG23050A
     C**********         EVAL(H)   WSysExchrt = @SPOT1 * @SPOT2                     CER043 BUG23050A
     C**********         ELSE                                                       CER043 BUG23050A
     C**********         EVAL(H)   WSysExchrt = 1 / (@SPOT1 * @SPOT2)               CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      ****Get**the highest Exchange rate tolerance                                  CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         IF        @NEXRT1 >= @NEXRT2                               CER043 BUG23050A
     C**********         EVAL      WRetp = @NEXRT1                                  CER043 BUG23050A
     C**********         EVAL      WCcy = DDBCCY                                    CER043 BUG23050A
     C**********         ELSE                                                       CER043 BUG23050A
     C**********         EVAL      WRetp = @NEXRT2                                  CER043 BUG23050A
     C**********         EVAL      WCcy = DDSCCY                                    CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      ****Compute for system deviation                                              CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         EVAL      WNorExchrt = %DEC(DDRAT1:13:8)                   CER043 BUG23050A
     C**********         IF        DDREIN = 'Y'                                     CER043 BUG23050A
     C**********         EVAL(H)   WDeviatn =                                       CER043 BUG23050A
     C**********                   %ABS(WSysExchrt - (1/WNorExchrt)) *100           CER043 BUG23050A
     C**********                   / WSysExchrt                                     CER043 BUG23050A
     C**********         ELSE                                                       CER043 BUG23050A
     C**********         EVAL(H)   WDeviatn =                                       CER043 BUG23050A
     C**********                   %ABS(WSysExchrt-WNorExchrt) *100 / WSysExchrt    CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         IF        WDeviatn > WRetp                                 CER043 BUG23050A
     C**********         EVAL      WIdx = WIdx + 1                                  CER043 BUG23050A
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDRAT1'                       CER043 BUG23050A
     C**********         EVAL      WMsgIDXAr(WIdx) = 'USR8007'                      CER043 BUG23050A
     C**********         EVAL      WRK1 = DDBCCY                                    CER043 BUG23050A
     C**********         EVAL      WRK2 = DDSCCY                                    CER043 BUG23050A
     C**********         EVAL      WRK3 = %CHAR(WDeviatn)                           CER043 BUG23050A
     C**********         EVAL      WRK4 = %CHAR(WRetp)                              CER043 BUG23050A
     C**********         EVAL      WRK5 = WCcy                                      CER043 BUG23050A
     C**********         EVAL      WMsgDtXAr(WIdx) = DSWRK                          CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         ENDIF                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
     C**********         ENDSR                                                      CER043 BUG23050A
      **********                                                                    CER043 BUG23050A
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C**********         PARM                    DDDLTP            2   deal type    BUG5578 AR720772
     C                   PARM                    DDDLTP            2                        MD039203
      *
     C**********         PARM                    DDRATE           13            exch rate     196952
     C                   PARM                    DDRAT1           14            exch rate     196952
     C                   PARM                    DDREIN                                       CER043
     C                   PARM                    @SPOT1           13 8                        CER043
     C                   PARM                    @@MDF1            1                          CER043
     C                   PARM                    @NEXRT1           5 2                        CER043
     C                   PARM                    @SPOT2           13 8                        CER043
     C                   PARM                    @@MDF2            1                          CER043
     C                   PARM                    @NEXRT2           5 2                        CER043
     C**********         PARM                    RelDXRT          13 8 OT deal rate BUG5578 AR720772
     C                   PARM                    RelOSRT          13 8                        248269
     C                   PARM                    S01453            1                          248269
     C                   PARM                    DDFPNT            8            fwd pts
     C                   PARM                    DDSIGN            1            fwd pts sgn
      *
      * Scaling Exponent 1 & 2
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@SXP2                         scaling exponent
      *
      ** Buy ccy Ok
      ** Sell ccy OK
     C                   PARM                    DDBccyOK          1            Buy ccy error
     C                   PARM                    DDSccyOK          1            Sell ccy error
      *
      * ICD
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CER043
     C                   PARM                    WMsgIDXAr                                    CER043
     C                   PARM                    WMsgDtXAr                                    CER043
      *
      ** Exchange Rate - OK
      ** Forward Points - OK
      ** Forward Points Sign - OK
     C                   PARM                    DDRateOK          1            err-exch rate
     C                   PARM                    DDFpntOK          1            err-fwd pts
     C                   PARM                    DDSignOK          1            err-fwd pts sgn
      *
      ** Input rate
      ** forward points
     C                   PARM                    W@INRT           13 8          rate (unscaled)
     C                   PARM                    F3FWPZ            7 2          fwd pts
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 102                                                CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @SF - Scaling Factors
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
