     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extension - Validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMES1VL - Depot Movement WI/WO extension - Validation*
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21221           Date 27Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP087             Date 18Aug05               *
      *                 225421  (BUG1356)  Date 03Mar04               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  BUG21221 - Applied fix BUG19956                              *
      *  BUG19956 - SEW7010 Confirmation Request error                *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to changes in file SEDMWIPD)         *
      *           and SEEDMWIPD)                                      *
      *  225421 - Validation of non-ISO15022 requirement should only  *
      *           being done based on the ISO15022 indicator only.    *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMGECONL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MG Cedel/Euroclear restrictions file
 
      /COPY WNCPYSRC,SEDME1V001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array used in EUCL validations
     D VA0             S              1    DIM(10) CTDATA PERRCD(10)
 
      ** Array for Instructions type validation (alphabetic)
     D VA1             S              3    DIM(10) CTDATA PERRCD(10)
 
      ** Array for Cedel codes validation (numeric)
     D VA2             S              3    DIM(30) CTDATA PERRCD(10)
 
      ** Array for Euroclear codes validation (numeric)
     D VA3             S              3    DIM(20) CTDATA PERRCD(10)
 
      ** Array used to split DSEUCL into individual characters
     D EU1             S              1    DIM(6)
 
      ** Array used to check Fungibility Codes
     D MGFUN           S              1    DIM(50)
 
     D NewDPMVFld    E DS                  EXTNAME(SEDMWIPD)
      ** New fields in screen format (whole API message from/to Caller)
 
     D DPMVOkFlags   E DS                  EXTNAME(SEEDMWIPD)
      ** SEDPMV Error Indicators flags
 
     D NewSEDMX1     E DS                  EXTNAME(SEVDMX1PD)
      ** New Extension File in file format
 
      ** Euroclear/Cedel code validation
     D SEUCL           DS            10
     D   SEU11                 1      1
     D   SEU14                 1      4
     D   SEU33                 3      3
     D   SEU27                 2      7
     D   SEU59                 5      9
     D   SEU51                 5     10
 
      ** Safekeeping Account
     D SSAFA           DS             6
     D   SSA26                 2      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for error message arrays
     D Idx             S              3P 0
 
      ** Index for warning message arrays
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SEDME1V002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SEDME1V003
 
      ** Validate Settlement message request
      *
     C                   EXSR      SRGMES
 
      /COPY WNCPYSRC,SEDME1V004
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME1V005
      *
      ** Validate Instructions type
      *
     C                   EXSR      SRINST
      *
      /COPY WNCPYSRC,SEDME1V006
      *
      ** Validate Instructions sub-type
      *
     C                   EXSR      SRINSS
      *
      /COPY WNCPYSRC,SEDME1V007
      *
      ** Validate Euroclear/Cedel code
      *
     C                   EXSR      SREUCL
      *
      /COPY WNCPYSRC,SEDME1V008
      *
      ** Validate Safekeeping Account
      *
     C                   EXSR      SRSAFA
      *
      /COPY WNCPYSRC,SEDME1V009
      *
      ** Validate Requested priority
      *
     C                   EXSR      SRRPTY
      *
      /COPY WNCPYSRC,SEDME1V010
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME1V011
 
      ** Validate Free or Against Payment
      *
     C                   EXSR      SRFIND
 
      /COPY WNCPYSRC,SEDME1V012
 
      ** Validate confirmation message request
      *
     C                   EXSR      SRGMEC
 
      /COPY WNCPYSRC,SEDME1V013
 
      ** Validate Time of transaction
      *
     C                   EXSR      SRTRTT
 
      /COPY WNCPYSRC,SEDME1V014
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME1V015
      *
      ** Validate Guaranteed delivery
      *
     C                   EXSR      SRGDEL
      *
      /COPY WNCPYSRC,SEDME1V016
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME1V017
 
      ** Validate Fungibility Code
      *
     C                   EXSR      SRFCOD
 
      /COPY WNCPYSRC,SEDME1V018
 
 B1  C     DS1522        IFNE      'Y'
     C*****CSE028        OREQ      'N'                                                        225421
     C     DSGMES        ANDEQ     'Y'                                                        225421
      *
      /COPY WNCPYSRC,SEDME1V019
      *
      ** Validate Sender's role
      *
     C                   EXSR      SRSROL
      *
      /COPY WNCPYSRC,SEDME1V020
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME1V021
 
      ** Validate ISO15022 Message
      ** If SWIFT 2002 Standards Update (CSW202) enhancement is on, bypass
      ** validation of ISO15022 message
      *
 B1  C     CSE028        IFEQ      'Y'
     C     CSE029        ANDEQ     'Y'
     C     CSW202        ANDEQ     'N'
      *
      /COPY WNCPYSRC,SEDME1V022
      *
     C                   EXSR      SR1522
      *
      /COPY WNCPYSRC,SEDME1V023
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME1V024
 
      ** Check if safekeeping account is entered on the second screen
      *
     C                   EXSR      SRVAL2
 
      /COPY WNCPYSRC,SEDME1V025
 
      ** If no error found, set up the valid file fields
      *
 B1  C                   IF        Idx = 0
      *
      /COPY WNCPYSRC,SEDME1V026
      *
     C                   EXSR      SetupValid
      *
      /COPY WNCPYSRC,SEDME1V027
      *
 E1  C                   ENDIF
 
      /COPY WNCPYSRC,SEDME1V028
 
      ** Return to the caller
      *
     C                   RETURN
 
      /COPY WNCPYSRC,SEDME1V029
 
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGMES    - Validate Settlement Message Request               *
      *****************************************************************
     C     SRGMES        BEGSR
      *
      ** Assumed to be 'Y' when left blank
      ** unless Depot Movement is in the Grey Market
      ** And Destination of Settlement is 'UNROUTABLE'
      *
     C     DSGMES        IFEQ      *BLANK
      *
     C     @MKTI         IFNE      'G'
     C     DDROTS        ANDNE     '  UNROUTABLE'
     C                   MOVE      'Y'           DSGMES
     C                   ELSE
     C                   MOVE      'N'           DSGMES
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If DSGMES is not 'Y' or 'N'
      *
     C     DSGMES        IFNE      'Y'
     C     DSGMES        ANDNE     'N'
     C                   EVAL      DSGMESOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSGMES'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5101'
     C                   ENDIF
      *
      ** If Settlement Message Request is 'Y', Depot Movement may not
      ** be in the Grey Market
      *
     C     DSGMES        IFEQ      'Y'
     C     @MKTI         ANDEQ     'G'
     C                   EVAL      DSGMESOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSGMES'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5292'
     C                   ENDIF
      *
      ** If Destination of Settlement is 'UNROUTABLE', then Settlement
      ** Message Request cannot be 'Y'
      *
     C     DSGMES        IFEQ      'Y'
     C     DDROTS        ANDEQ     '  UNROUTABLE'
     C                   EVAL      DSGMESOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSGMES'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9001'
     C                   ENDIF
      *
      ** If settlement message request was previously 'Y' then issue
      ** a warning message if the user changes this value. The message
      ** will inform the user that outstanding settlements may exist for
      ** this depot movement
      *
     C     SVACTN        IFEQ      'A'
     C     VDPGMES       ANDEQ     'Y'
     C     VDPGMES       ANDNE     DSGMES
     C                   EVAL      DSGMESOK = 'W'
     C     WIdx          COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             WIdx
     C   99              EVAL      WFldNamArr(WIdx) = 'DSGMES'
     C   99              EVAL      WMsgIdArr(WIdx)   = 'SEW5853'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINST    - Validate Instructions Type                        *
      *****************************************************************
     C     SRINST        BEGSR
      *
      ** Check the following for MT580 only
      *
 B1  C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
      ** A settlement message is requested
      *
 B2  C     DSGMES        IFEQ      'N'
      *
 B3  C     DSINST        IFNE      *BLANKS
     C                   EVAL      DSINSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINST'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
      ** Check instructions type as a alpha input field
      *
     C     DSINST        LOOKUP    VA1                                    86
      *
      ** If not found and sent to Cedel
      ** (Note MT580 have only Cedel or Euroclear destination)
      *
 B3  C     *IN86         IFEQ      '0'
     C     @CLAS         ANDEQ     'C'
      *
     C     DSINST        LOOKUP    VA2                                    86
      *
 B4  C     *IN86         IFEQ      '0'
     C                   EVAL      DSINSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINST'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5102'
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
      ** If not found and sent to Euroclear
      *
 B3  C     *IN86         IFEQ      '0'
     C     @CLAS         ANDEQ     'E'
      *
     C     DSINST        LOOKUP    VA3                                    86
      *
 B4  C     *IN86         IFEQ      '0'
     C                   EVAL      DSINSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINST'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5103'
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      * Must not be blank if clearance type is not 1, 2, 3 or 4
      *
 B2  C     DSINST        IFNE      *BLANKS
     C                   EVAL      DSINSTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINST'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5111'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINSS    - Validate Instructions Sub-Type                    *
      *****************************************************************
     C     SRINSS        BEGSR
      *
      ** Key for MGECONL0: Destination, Trans. type,
      **                   Instructions type and sub-type
      *
     C                   MOVEL     *BLANKS       KMGECO           20
      *
 B1  C                   IF        @CLAS = 'E'
     C                   EVAL      KMGECO = 'EOC  ' + @INST + DSINST + DSINSS
 E1  C                   ENDIF
      *
 B1  C                   IF        @CLAS = 'C'
     C                   EVAL      KMGECO = 'CEDEL' + @INST + DSINST + DSINSS
 E1  C                   ENDIF
      *
      ** Check the following for MT580 only
      *
 B1  C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
      ** A settlement message is requested
      *
 B2  C     DSGMES        IFEQ      'N'
      *
 B3  C     DSINSS        IFNE      *BLANKS
     C                   EVAL      DSINSSOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINSS'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
      ** Check internal or bridge instructions sub-type
      *
 B3  C     DSINST        IFEQ      'INT'
     C     DSINST        OREQ      'BRI'
      *
 B4  C     DSINSS        IFNE      'SETTL'
     C     DSINSS        ANDNE     'MATCH'
     C     DSINSS        ANDNE     'TRANS'
     C                   EVAL      DSINSSOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINSS'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5104'
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
      ** Check external sub-type
      *
 B3  C     DSINST        IFEQ      'EXT'
      *
 B4  C     DSINSS        IFNE      'BOOK '
     C     DSINSS        ANDNE     ' BOOK'
     C     DSINSS        ANDNE     'PHYSI'
     C                   EVAL      DSINSSOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINSS'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5105'
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
      ** Check instructions sub-type depending of type of delivering
      *
     C     KMGECO        CHAIN     MGECOND1                           86
      *
 B3  C     *IN86         IFEQ      '1'
     C                   EVAL      DSINSSOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINSS'
      *
 B4  C   99              SELECT
 X4  C     @INST         WHENEQ    'RECFREE'
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5107'
      *
 X4  C     @INST         WHENEQ    'RECAPMT'
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5108'
      *
 X4  C     @INST         WHENEQ    'DELFREE'
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5109'
      *
 X4  C     @INST         WHENEQ    'DELAPMT'
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5110'
      *
 X4  C                   OTHER
     C                   EVAL      MsgIdArr(Idx)   = 'SEW5102'
 E4  C                   ENDSL
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
      *
 B2  C     DSINSS        IFNE      *BLANKS
     C                   EVAL      DSINSSOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSINSS'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5112'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREUCL    - Validate EuroClear/Cedel Code                     *
      *****************************************************************
     C     SREUCL        BEGSR
      *
     C                   SETOFF                                       24
      *
      ** Check the following for MT580 only
      *
 B1  C                   IF        @CLAS = 'E' OR @CLAS = 'C'
     C                   EVAL      SEUCL = DSEUCL
      *
      ** A settlement message is requested
      *
 B2  C     DSGMES        IFEQ      'N'
      *
 B3  C     DSEUCL        IFNE      *BLANKS
     C                   EVAL      DSEUCLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSEUCL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
      ** DSEUCL must start by  "//XC" or "//XE" or "/"
      *
 B3  C     SEU11         IFNE      '/'
     C     SEU14         ANDNE     '//XC'
     C     SEU14         ANDNE     '//XE'
     C                   SETON                                        24
 E3  C                   ENDIF
      *
      ** DSEUCL must be a 5 or 6 digits number
      *
 B3  C     SEU33         IFEQ      'X'
     C                   MOVE      SEU51         WZEUCL            6
 X3  C                   ELSE
      *
 B4  C     SEU11         IFEQ      '/'
     C                   MOVE      SEU27         WZEUCL
 X4  C                   ELSE
     C                   MOVEL     SEUCL         WZEUCL
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
     C                   MOVEA     WZEUCL        EU1
     C                   SETOFF                                       85
     C                   Z-ADD     0             I                 2 0
      *
 B3  C     I             DOWLE     4
     C     *IN24         ANDEQ     '0'
     C                   ADD       1             I
      *
 B4  C     EU1(I)        IFEQ      ' '
     C                   SETON                                        24
 X4  C                   ELSE
     C     EU1(I)        LOOKUP    VA0                                    85
      *
 B5  C     *IN85         IFEQ      '0'
     C                   SETON                                        24
 E5  C                   ENDIF
      *
 E4  C                   ENDIF
      *
 E3  C                   ENDDO
      *
      ** Euroclear/Cedel Code is not valid
      *
 B3  C     *IN24         IFEQ      '1'
     C                   EVAL      DSEUCLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSEUCL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5115'
 E3  C                   ENDIF
      *
      ** For external instructions //XC or //XE is not allowed
      *
 B3  C     DSINST        IFEQ      '6F '
     C     DSINST        OREQ      '61 '
     C     DSINST        OREQ      '8A '
     C     DSINST        OREQ      '8D '
     C     DSINST        OREQ      '8M '
     C     DSINST        OREQ      '81 '
     C     DSINST        OREQ      'EXT'
      *
 B4  C     SEU14         IFEQ      '//XC'
     C     SEU14         OREQ      '//XE'
     C                   EVAL      DSEUCLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSEUCL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5117'
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
      *
 B2  C     DSEUCL        IFNE      *BLANKS
     C                   EVAL      DSEUCLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSEUCL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5116'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSAFA    - Validate SafeKeeping Account                      *
      *****************************************************************
     C     SRSAFA        BEGSR
      *
     C                   SETOFF                                       2425
      *
      ** Check the following for MT580 only
      *
 B1  C                   IF        @CLAS = 'C' OR @CLAS = 'E'
     C                   EVAL      SSAFA = DSSAFA
      *
      ** A settlement message is requested
      *
 B2  C     DSGMES        IFEQ      'N'
      *
 B3  C     DSSAFA        IFNE      *BLANKS
     C                   EVAL      DSSAFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSAFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
      ** DSSAFA must start by a slash "/"
      *
     C                   MOVEL     DSSAFA        WWSAFA            1
      *
 B3  C     WWSAFA        IFNE      '/'
     C                   SETON                                        25
 E3  C                   ENDIF
      *
      ** DSSAFA must be a 5 digits number
      *
     C                   MOVEA     DSSAFA        EU1
     C                   SETOFF                                       85
     C                   Z-ADD     1             I
      *
 B3  C     I             DOWLE     5
     C     *IN25         ANDEQ     '0'
     C                   ADD       1             I
      *
 B4  C     EU1(I)        IFEQ      ' '
     C                   SETON                                        25
 X4  C                   ELSE
     C     EU1(I)        LOOKUP    VA0                                    85
      *
 B5  C     *IN85         IFEQ      '0'
     C                   SETON                                        25
 E5  C                   ENDIF
      *
 E4  C                   ENDIF
      *
 E3  C                   ENDDO
      *
      ** Safekeeping A/c is not valid
      *
 B3  C     *IN25         IFEQ      '1'
     C                   EVAL      DSSAFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSAFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5120'
 E3  C                   ENDIF
      *
      ** Euroclear/Cedel must be different as Safekeeping Account
      *
     C                   MOVEL     *BLANKS       AAEUCL            6
      *
 B3  C     DSSAFA        IFNE      *BLANKS
     C                   MOVEL     DSEUCL        AAEUCL
      *
 B4  C     AAEUCL        IFEQ      DSSAFA
     C                   SETON                                        24
 X4  C                   ELSE
      *
 B5  C     SEU14         IFEQ      '//XC'
     C     SEU59         ANDEQ     SSA26
     C     SEU14         OREQ      '//XE'
     C     SEU59         ANDEQ     SSA26
     C                   SETON                                        24
 E5  C                   ENDIF
      *
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
 B3  C     *IN24         IFEQ      '1'
     C                   EVAL      DSEUCLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSEUCL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5121'
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
      *
 B2  C     DSSAFA        IFNE      *BLANKS
     C                   EVAL      DSSAFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSAFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5122'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRPTY    - Validate Requested Priority Field                 *
      *****************************************************************
     C     SRRPTY        BEGSR
      *
      ** A settlement message is requested
      *
 B1  C     DSGMES        IFEQ      'N'
      *
 B2  C     DSRPTY        IFNE      *BLANKS
     C                   EVAL      DSRPTYOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRPTY'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      ** If SRPTY is not '1', '2', '3' , '4' or blank
      *
 B2  C     DSRPTY        IFNE      '1'
     C     DSRPTY        ANDNE     '2'
     C     DSRPTY        ANDNE     '3'
     C     DSRPTY        ANDNE     '4'
     C     DSRPTY        ANDNE     *BLANKS
     C                   EVAL      DSRPTYOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRPTY'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5125'
 E2  C                   ENDIF
      *
 B2  C     @CLAS         IFEQ      'C'
     C     DSRPTY        ANDEQ     '4'
     C                   EVAL      DSRPTYOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSRPTY'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5126'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFIND - Validate Free or against payment Ind.                *
      *****************************************************************
     C     SRFIND        BEGSR
      *
      ** Default to 'F' if not 'A'
      *
     C     DSFIND        IFNE      'A'
     C                   EVAL      DSFIND   = 'F'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGMEC    - Validate Confirmation Message Request             *
      *****************************************************************
     C     SRGMEC        BEGSR
      *
      ** Cannot be 'Y' for WI/WO
      *
     C     DSGMEC        IFEQ      'Y'
     C     DPMVType      ANDNE     'RR'                                                     BUG19956
     C     DPMVType      ANDNE     'RP'                                                     BUG19956
     C     DPMVType      ANDNE     'PD'                                                     BUG19956
     C     DPMVType      ANDNE     'PL'                                                     BUG19956
     C                   EVAL      DSGMECOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSGMEC'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW7010'
     C                   ENDIF
      *
      ** Default DSGMEC to 'N' if not 'Y'
      *
     C     DSGMEC        IFNE      'Y'
     C                   EVAL      DSGMEC   = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTRTT    - Validate Time of Transaction Field                *
      *****************************************************************
     C     SRTRTT        BEGSR
      *
      ** Time is mandatory for instructions sent to Cedel
      *
     C     DSTRTT        IFEQ      *BLANKS
     C     @CLAS         ANDEQ     'C'
     C     DSGMES        ANDEQ     'Y'
     C                   EVAL      DSTRTTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSTRTT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5146'
     C                   ENDIF
      *
      ** Check time is valid
      *
     C     DSTRTT        IFNE      *BLANKS
     C                   MOVEL     DSTRTT        WWNUM5            5 0
     C                   MOVEL     WWNUM5        WWALF4            4
     C                   MOVEL     DSTRTT        WWHOUR            2 0
     C                   MOVE      DSTRTT        WWMINS            2 0
      *
     C     DSTRTT        IFNE      WWALF4
     C     WWHOUR        ORGT      23
     C     WWHOUR        ORLT      0
     C     WWMINS        ORGT      59
     C     WWMINS        ORLT      0
     C                   EVAL      DSTRTTOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSTRTT'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5147'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGDEL    - Validate Guaranteed Delivery Field                *
      *****************************************************************
     C     SRGDEL        BEGSR
      *
      ** A settlement message is requested
      *
     C     DSGMES        IFEQ      'N'
      *
     C     DSGDEL        IFNE      *BLANKS
     C                   EVAL      DSGDELOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSGDEL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If DSGDEL is not 'G' or blank
      *
     C     DSGDEL        IFNE      'G'
     C     DSGDEL        ANDNE     *BLANKS
     C                   EVAL      DSGDELOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSGDEL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5150'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFCOD    - Validate Fungibility Code Field                   *
      *****************************************************************
     C     SRFCOD        BEGSR
      *
      ** Check the following for MT580 only
      *
 B1  C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
      ** A settlement message is requested
      *
 B2  C     DSGMES        IFEQ      'N'
      *
 B3  C     DSFCOD        IFNE      *BLANKS
     C                   EVAL      DSFCODOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFCOD'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
 B3  C     DSFCOD        IFNE      *BLANKS
     C     @CLAS         ANDNE     'C'
     C                   EVAL      DSFCODOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFCOD'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5155'
 E3  C                   ENDIF
      *
      ** If DSFCOD is not '0', '1', '2' , '3', '5', '6', '7' or blank
      *
 B3  C     DSFCOD        IFNE      '0'
     C     DSFCOD        ANDNE     '1'
     C     DSFCOD        ANDNE     '2'
     C     DSFCOD        ANDNE     '3'
     C     DSFCOD        ANDNE     '5'
     C     DSFCOD        ANDNE     '6'
     C     DSFCOD        ANDNE     '7'
     C     DSFCOD        ANDNE     *BLANKS
     C                   EVAL      DSFCODOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFCOD'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5156'
 E3  C                   ENDIF
      *
      ** Check combinations between instructions and fungibility codes
      ** (for Cedel)
      *
 B3  C     @CLAS         IFEQ      'C'
     C     KMGECO        CHAIN     MGECOND1                           85
      *
 B4  C     *IN85         IFEQ      '0'
     C                   MOVEA     MGXFUN        MGFUN
     C     DSFCOD        LOOKUP    MGFUN                                  85
      *
 B5  C     *IN85         IFEQ      '0'
     C                   EVAL      DSFCODOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFCOD'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5157'
 E5  C                   ENDIF
      *
 E4  C                   ENDIF
      *
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
      *
 B2  C     DSFCOD        IFNE      *BLANKS
     C                   EVAL      DSFCODOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSFCOD'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5159'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSROL    - Validate Sender's Role                            *
      *****************************************************************
     C     SRSROL        BEGSR
      *
      ** Check the following for MT580 only
      *
 B1  C                   IF        @CLAS = 'E' OR @CLAS = 'C'
      *
      ** A settlement message is requested
      *
 B2  C     DSGMES        IFEQ      'N'
      *
 B3  C     DSSROL        IFNE      *BLANKS
     C                   EVAL      DSSROLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSROL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5170'
 E3  C                   ENDIF
      *
 X2  C                   ELSE
      *
      ** If DSSROL  is not AGEN, CUST, PRIN or blank
      *
 B3  C     DSSROL        IFNE      'AGEN'
     C     DSSROL        ANDNE     'CUST'
     C     DSSROL        ANDNE     'PRIN'
     C     DSSROL        ANDNE     *BLANKS
     C                   EVAL      DSSROLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSROL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5165'
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
      *
      ** Must not be entered if clearance type is not 1, 2, 3 or 4
      *
 B2  C     DSSROL        IFNE      *BLANKS
     C                   EVAL      DSSROLOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSROL'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW5166'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR1522    - Validate ISO15022 Message Indicator               *
      *****************************************************************
     C     SR1522        BEGSR
      *
 B1  C     DS1522        IFEQ      *BLANKS
     C     SVACTN        ANDEQ     'I'
     C                   MOVE      'Y'           DS1522
 E1  C                   ENDIF
      *
 B1  C     DS1522        IFEQ      'Y'
     C     DS1522        OREQ      'N'
     C     DS1522        OREQ      *BLANKS
      *
 B2  C     SVACTN        IFEQ      'A'
      *
 B3  C     VDPNEW        IFNE      DS1522
     C     VDPGMES       ANDEQ     'Y'
     C     VDPLSWS       ANDGT     1
     C                   EVAL      DS1522OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DS1522'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE10037'
 E3  C                   ENDIF
      *
      ** If Amend and ISO15022 is blanked out and no swift message generated yet
      ** then default value to 'N'
      *
 B3  C     DS1522        IFEQ      *BLANK
     C     VDPLSWS       ANDLE     1
     C                   MOVE      'N'           DS1522
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 X1  C                   ELSE
     C                   EVAL      DS1522OK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DS1522'
     C   99              EVAL      MsgIdArr(Idx)   = 'SE10030'
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVAL2 - Check if safekeeping account is entered on screen 2  *
      *****************************************************************
     C     SRVAL2        BEGSR
      *
      ** Validate safekeeping account.
      *
     C     DS1522        IFEQ      'Y'
     C     DSGMES        ANDEQ     'Y'
     C     CSE028        ANDEQ     'Y'
     C     CSW202        ANDNE     'Y'
      *
     C     DSSAFA        IFEQ      *BLANKS
     C     DSSKAL        ANDEQ     *BLANKS
     C                   EVAL      DSSAFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSAFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9004'
     C                   ENDIF
      *
     C     DSSAFA        IFNE      *BLANKS
     C     DSSKAL        ANDNE     *BLANKS
     C                   EVAL      DSSAFAOK = 'N'
     C     Idx           COMP      ArrayMax                             99      -Lower-
     C   99              ADD       1             Idx
     C   99              EVAL      FldNameArr(Idx) = 'DSSAFA'
     C   99              EVAL      MsgIdArr(Idx)   = 'SEW9007'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupValid - Set up the valid file fields                     *
      *****************************************************************
     C     SetupValid    BEGSR
      *
     C                   IF        SVACTN = 'I'
     C                   MOVE      DDDPSS        VDPDPSS
     C                   MOVE      DDDPRN        VDPDPRN
     C                   ENDIF
      *
     C                   MOVE      DSGMES        VDPGMES
     C                   MOVE      DSINST        VDPINST
     C                   MOVE      DSINSS        VDPINSS
     C                   MOVE      DSEUCL        VDPEUCL
     C                   MOVE      DSSAFA        VDPSAFA
     C                   MOVE      DSRPTY        VDPRPTY
     C                   MOVE      DSFIND        VDPFIND
     C                   MOVE      DSGMEC        VDPGMEC
     C                   MOVE      DSTRTT        VDPTRTT
     C                   MOVE      DSGDEL        VDPGDEL
     C                   MOVE      DSFCOD        VDPFCOD
     C                   MOVE      DSSROL        VDPSROL
     C                   MOVE      'Y'           VDPSCMG
      *
     C     CSW003        IFEQ      'Y'
     C                   MOVE      'S'           VDPWHEN
     C                   ENDIF
      *
     C     CSE028        IFEQ      'Y'
     C     DS1522        OREQ      'Y'                                                        225421
     C                   MOVE      DS1522        VDPNEW
     C                   MOVE      DSSTST        VDPSTMP
     C                   MOVE      DSCHID        VDPCHID
     C                   MOVE      DSTRRM        VDPTRRM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Actual Action Code
     C                   PARM                    SVACTN            1
      ** Screen Fields
     C                   PARM                    NewDPMVFld
      ** Depot movement type                                                                BUG19956
     C                   PARM                    DPMVType          2                        BUG19956
      ** Additional screen field (destination of settlement)
     C                   PARM                    DDROTS           12
      ** Calculated Instructions Type
     C                   PARM                    @INST             7
      ** Security Customer classification
     C                   PARM                    @CLAS             1
      ** Security information: Market Indicator
     C                   PARM                    @MKTI             1
      ** Features Status
     C                   PARM                    CSE028            1
     C                   PARM                    CSE029            1
     C                   PARM                    CSW003            1
     C                   PARM                    CSW202            1
      *
      ** OUTPUT PARAMETERS
      ** Error indicator flags from/to caller
     C                   PARM                    DPMVOkFlags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
      ** Valid Core Extension details layout (DS) from/to caller
     C                   PARM                    NewSEDMX1
      *
      /COPY WNCPYSRC,SEDME1V030
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      /COPY WNCPYSRC,SEDME1V031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
**CTDATA VA0
0123456789
**CTDATA VA1
INTBRIEXT#####################
**CTDATA VA2
31  3141  414F  4F4T  4T51  51
5F  5F5T  5T61  616F  6F81  81
8A  8A8D  8D8M  8M############
**CTDATA VA3
01 02 03 03C03K07 07C07K######
##############################
