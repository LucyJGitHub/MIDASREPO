     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate backward-looking rate fields')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  ZAVBLRTE - Validate backward-looking rate fields             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Backward-Looking Rate fields and confirms whether *
      *             they have valid values.                           *
      *             If the flds are valid, the returncode 10A will be *
      *             blank and the passed flds will contain valid      *
      *             formatted values (ready to be stored).            *
      *             If one of the flds is invalid, the returncode     *
      *             will contain 'Error' and an error message will be *
      *             returned.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172 *CREATE     Date 01Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7, U8     Database error                                  *
      *    20         No Loan reference found                         *
      *    29         No Loan reference input                         *
      *    30         No Currency and BaseRateCode input              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SDBLRT - Default Backward-Looking Rate                       *
      *  SRBLRT - Validate Backward-Looking Rate                      *
      *  SDAVOP - Default Averaging Option                            *
      *  SRAVOP - Validate Averaging Option                           *
      *  SDLBDY - Default Lookback Days for Settlement                *
      *  SRLBDY - Validate Lookback Days for Settlement               *
      *  SDLODY - Default Lockout Days                                *
      *  SRLODY - Validate Lockout Days                               *
      *  SDWGHT - Default Weight Convention                           *
      *  SRWGHT - Validate Weight Convention                          *
      *  SDBADJ - Default Benchmark Adjustment                        *
      *  SRBADJ - Validate Benchmark Adjustment                       *
      *  SDPDLY - Default Payment Delay Days                          *
      *  SRPDLY - Validate Payment Delay Days                         *
      *  SDNVOP - Default Averaging Option                            *
      *  SRNBDY - Validate Lookback Days for Settlement               *
      *  SDNODY - Default Lockout Days                                *
      *  SRRODY - Validate Lockout Days                               *
      *  SDNGHT - Default Weight Convention                           *
      *  SRNGHT - Validate Weight Convention                          *
      *  SDNADJ - Default Benchmark Adjustment                        *
      *  SRNADJ - Validate Benchmark Adjustment                       *
      *  SDNDLY - Default Payment Delay Days                          *
      *  SRNDLY - Validate Payment Delay Days                         *
      *  SDCART - Default Compounded/Average Rate                     *
      *  SRCART - Validate Compounded/Average Rate                    *
      *  SDBRAC - Default Base Rate for Accrual                       *
      *  SDLBAC - Default Lookback Days for Accrual                   *
      *  SDPIAD - Default Principal Interest Control Date             *
      *  SRFRSHRO - Determine if First Rollover Event                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D/COPY ZACPYSRC,PSDS

      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D NumBlank        C                   CONST('0123456789 ')

      *
      ** The maximum size of the appended error arrays
      *
     D XArrayMax       C                   CONST(40)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      *
      ** Array of fields in error
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      *
      ** Array of error message IDs
      *
     D MsgIdXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
	
      *
      ** Array for Input
      *
     D ArrayInp        S              1A   DIM(200)

      *
      ** DS for Access Programs: Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access programs: Long Sata Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)

      *
      ** DS for SC Switchable Features
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for General Ledger details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** DS for Dealing details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D                                     PREFIX(DL)
      *
      ** DS for Base Rate details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(B)
      *
      ** DS for Base rate for Accrual details
      *
     D SDBRACDS      E DS                  EXTNAME(SDBSRTPD)
     D                                     PREFIX(Z)
      *
      ** DS for Loan details
      *
     D LECLOAN       E DS                  EXTNAME(LECLIPL2:*INPUT)
     D                                     PREFIX(H)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

     D ApiName         S              4A

      *
      ** Index for arrays of error message ids
      *
     D Idx             S              3P 0
      *
      ** Passed index value
      *
     D Ix              S              3P 0

      *
      ** Input Screen fields
      *
     D InpScrfld       DS           200
      *
      ** Output Valid fields
      *
     D OutValfld       DS           200

      *
      ** CLIP Backward-Looking Rate Valid fields (Output)
      *
     D CLBsrValfld     DS
     D  CVBLRT                 1      1A
     D  CVLBDY                 2      3S 0
     D  CVNBDY                 4      5S 0
     D  CVLODY                 6      7S 0
     D  CVNODY                 8      9S 0
     D  CVPDLY                10     11S 0
     D  CVNDLY                12     13S 0
     D  CVBADJ                14     20P 8
     D  CVNADJ                21     27P 8
     D  CVAVOP                28     28A
     D  CVNVOP                29     29A
     D  CVCART                30     36P 8
     D  CVWGHT                37     37A
     D  CVNGHT                38     38A
     D  CVBRAC                39     40A
     D  CVLBAC                41     42S 0
     D  CVPIAD                43     47S 0

      *
      ** LOAM Backward-Looking Rate Valid fields (Output)
      *
     D LoamValFld      DS
     D  LVAVOP                 1      1A
     D  LVLBDY                 2      3S 0
     D  LVLODY                 4      5S 0
     D  LVWGHT                 6      6A
     D  LVBADJ                 7     13P 8
     D  LVPDLY                14     15S 0

      *
      ** LERI Backward-Looking Rate Valid fields (Output)
      *
     D LeriValFld      DS
     D  LVNVOP                 1      1A
     D  LVNBDY                 2      3S 0
     D  LVNODY                 4      5S 0
     D  LVNGHT                 6      6A
     D  LVNADJ                 7     13P 8
     D  LVNDLY                14     15S 0

      *
      ** Parameters for access object AOSARDR0
      *
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PKEY1           S              3A
     D PKEY2           S              2A
     D CLE172          S              1A
	
      *
      ** Parameters for calling ZA0841
      *
     D @@ALPH          S             16A
     D @@MTID          S              1A
     D @@AMT           S             15P 0
     D @@ERCD          S              1P 0
     D @@IDP           S              3P 0
     D @@IINT          S              3P 0

     D #1TESTN         S              1A
     D #2TESTN         S              1A
     D #1CHARPOS       S              2P 0
     D #2CHARPOS       S              2P 0
     D WDAY            S              2S 0
     D WNumBadj        S             13P 8
     D WNumNadj        S             13P 8
     D WNumCart        S             13P 8
     D WSign           S              1A

      *
      ** Work fields for base rate key list
      *
     D WFCYCD          S              3A
     D WFBSRC          S              2A
      *
      ** Work fields for cloancl key list
      *
     D WFLNRF          S              6A
      *
      ** Other work fields
      *
     D WFCALB          S              1S 0
     D FreshRO         S              1A

      *
      ** Generic screen fields
      *
     D  DDBLRT         S              1A
     D  DDLBDY         S              2A
     D  DDNBDY         S              2A
     D  DDLODY         S              2A
     D  DDNODY         S              2A
     D  DDPDLY         S              2A
     D  DDNDLY         S              2A
     D  DDBADJ         S             15A
     D  DDNADJ         S             15A
     D  DDAVOP         S              1A
     D  DDNVOP         S              1A
     D  DDCART         S             15A
     D  DDWGHT         S              1A
     D  DDNGHT         S              1A

      *
      ** Generic valid fields
      *
     D  VBLRT          S              1A
     D  VLBDY          S              2S 0
     D  VNBDY          S              2S 0
     D  VLODY          S              2S 0
     D  VNODY          S              2S 0
     D  VPDLY          S              2S 0
     D  VNDLY          S              2S 0
     D  VBADJ          S             13P 8
     D  VNADJ          S             13P 8
     D  VAVOP          S              1A
     D  VNVOP          S              1A
     D  VCART          S             13P 8
     D  VWGHT          S              1A
     D  VNGHT          S              1A
     D  VBRAC          S              2A
     D  VLBAC          S              2S 0
     D  VPIAD          S              5S 0

      *
      ** OK fields
      *
     D DDBLRTOK        S              1A
     D DDAVOPOK        S              1A
     D DDLBDYOK        S              1A
     D DDLODYOK        S              1A
     D DDWGHTOK        S              1A
     D DDBADJOK        S              1A
     D DDPDLYOK        S              1A
     D DDNVOPOK        S              1A
     D DDNBDYOK        S              1A
     D DDNODYOK        S              1A
     D DDNGHTOK        S              1A
     D DDNADJOK        S              1A
     D DDNDLYOK        S              1A
     D DDCARTOK        S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   EXSR      RSTFLDS
      *
     C     ApiName       IFEQ      'CLIP'
     C                   MOVEA     InpScrfld     ArrayInp
     C                   MOVEA     ArrayInp(1)   DDBLRT
     C                   MOVEA     ArrayInp(2)   DDLBDY
     C                   MOVEA     ArrayInp(4)   DDLODY
     C                   MOVEA     ArrayInp(6)   DDPDLY
     C                   MOVEA     ArrayInp(8)   DDBADJ
     C                   MOVEA     ArrayInp(23)  DDAVOP
     C                   MOVEA     ArrayInp(24)  DDCART
     C                   MOVEA     ArrayInp(38)  DDWGHT
      *
     C                   EXSR      SDBLRT
     C                   EXSR      SRBLRT
      *
     C                   EXSR      SDLBDY
     C                   EXSR      SRLBDY
      *
     C                   EXSR      SDLODY
     C                   EXSR      SRLODY
      *
     C                   EXSR      SDPDLY
     C                   EXSR      SRPDLY
      *
     C                   EXSR      SDBADJ
     C                   EXSR      SRBADJ
      *
     C                   EXSR      SDAVOP
     C                   EXSR      SRAVOP
      *
     C                   EXSR      SDCART
     C                   EXSR      SRCART
      *
     C                   EXSR      SDWGHT
     C                   EXSR      SRWGHT
      *
     C                   EXSR      SDBRAC
     C                   EXSR      SDLBAC
     C                   EXSR      SDPIAD
     C                   EXSR      SDNBDY
     C                   EXSR      SDNODY
     C                   EXSR      SDNDLY
     C                   EXSR      SDNADJ
     C                   EXSR      SDNGHT
     C                   EXSR      SDNVOP
     C                   MOVE      VBLRT         CVBLRT
     C                   Z-ADD     VLBDY         CVLBDY
     C                   Z-ADD     VNBDY         CVNBDY
     C                   Z-ADD     VLODY         CVLODY
     C                   Z-ADD     VNODY         CVNODY
     C                   Z-ADD     VPDLY         CVPDLY
     C                   Z-ADD     VNDLY         CVNDLY
     C                   Z-ADD     VBADJ         CVBADJ
     C                   Z-ADD     VNADJ         CVNADJ
     C                   MOVE      VAVOP         CVAVOP
     C                   MOVE      VNVOP         CVNVOP
     C                   Z-ADD     VCART         CVCART
     C                   MOVE      VWGHT         CVWGHT
     C                   MOVE      VNGHT         CVNGHT
     C                   MOVE      VBRAC         CVBRAC
     C                   Z-ADD     VLBAC         CVLBAC
     C                   Z-ADD     VPIAD         CVPIAD
     C                   MOVEL     CLBsrValfld   OutValfld
     C                   ENDIF
      *
      ** LOAM BC
      *
     C     ApiName       IFEQ      'LOAM'          			

     C                   MOVEA     InpScrfld     ArrayInp
     C                   MOVEA     ArrayInp(1)   DDAVOP
     C                   MOVEA     ArrayInp(2)   DDLBDY
     C                   MOVEA     ArrayInp(4)   DDLODY
     C                   MOVEA     ArrayInp(6)   DDWGHT
     C                   MOVEA     ArrayInp(7)   DDBADJ
     C                   MOVEA     ArrayInp(21)  DDPDLY
      *
     C                   EXSR      SDBLRT
     C                   EXSR      SRBLRT
      *
     C                   EXSR      SDAVOP
     C                   EXSR      SRAVOP
     C                   MOVE      VAVOP         LVAVOP
      *
     C                   EXSR      SDLBDY
     C                   EXSR      SRLBDY
     C                   Z-ADD     VLBDY         LVLBDY
      *
     C                   EXSR      SDLODY
     C                   EXSR      SRLODY
     C                   Z-ADD     VLODY         LVLODY
      *
     C                   EXSR      SDWGHT
     C                   EXSR      SRWGHT
     C                   MOVE      VWGHT         LVWGHT
      *
     C                   EXSR      SDBADJ
     C                   EXSR      SRBADJ
     C                   Z-ADD     VBADJ         LVBADJ
      *
     C                   EXSR      SDPDLY
     C                   EXSR      SRPDLY
     C                   Z-ADD     VPDLY         LVPDLY
     C                   MOVEL     LoamValFld    OutValfld
     C                   ENDIF
      *
      ** LERI
      *
     C     ApiName       IFEQ      'LERI'
     C                   MOVEA     InpScrfld     ArrayInp
     C                   MOVEA     ArrayInp(1)   DDNVOP
     C                   MOVEA     ArrayInp(2)   DDNBDY
     C                   MOVEA     ArrayInp(4)   DDNODY
     C                   MOVEA     ArrayInp(6)   DDNGHT
     C                   MOVEA     ArrayInp(7)   DDNADJ
     C                   MOVEA     ArrayInp(22)  DDNDLY
      *
     C                   EXSR      SDBLRT
     C                   EXSR      SRBLRT
      *
     C                   EXSR      SRFRSHRO
      *
     C                   EXSR      SDNVOP
     C                   EXSR      SRNVOP
     C                   MOVE      VNVOP         LVNVOP
      *
     C                   EXSR      SDNBDY
     C                   EXSR      SRNBDY
     C                   Z-ADD     VNBDY         LVNBDY
      *
     C                   EXSR      SDNODY
     C                   EXSR      SRNODY
     C                   Z-ADD     VNODY         LVNODY
      *
     C                   EXSR      SDNGHT
     C                   EXSR      SRNGHT
     C                   MOVE      VNGHT         LVNGHT
      *
     C                   EXSR      SDNADJ
     C                   EXSR      SRNADJ
     C                   Z-ADD     VNADJ         LVNADJ
      *
     C                   EXSR      SDNDLY
     C                   EXSR      SRNDLY
     C                   Z-ADD     VNDLY         LVNDLY
     C                   MOVEL     LeriValFld    OutValfld
     C                   ENDIF
      *
      ** LOAM SC
      *
     C     ApiName       IFEQ      'LOSC'
     C                   MOVEA     InpScrfld     ArrayInp
     C                   MOVEA     ArrayInp(7)   DDBADJ
      *
     C                   EXSR      SDBLRT
     C                   EXSR      SRBLRT
      *
     C                   EXSR      SDBADJ
     C                   EXSR      SRBADJ
     C                   Z-ADD     VBADJ         LVBADJ
      *
     C                   MOVEL     LoamValFld    OutValfld
     C                   ENDIF
      *
      ** If a new error was found, set the return code appropriately
      *
     C                   IF        Idx > Ix
     C                   EVAL      RetCodeOut = 'Error'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ApiName                        In Param
     C                   PARM                    WFCYCD                         In param
     C                   PARM                    WFBSRC                         In param
     C                   PARM                    WFLNRF                         In param
      *                  PARM                    WFCALB                         In param
     C                   PARM                    InpScrfld                      In/Out param
     C                   PARM                    Idx                            In/Out param
     C                   PARM                    FldNamXAr                      In/Out param
     C                   PARM                    MsgIdXAr                       In/Out param
     C                   PARM                    OutValfld                      Out param
     C                   PARM                    RetCodeOut                     Out param
      *
      **  Key list for CLOANCL
      *
     C     WKCLOANR      KLIST
     C                   KFLD                    WFLNRF
      *
     C                   SETOFF                                       29
     C     WFLNRF        IFEQ      *BLANKS
     C                   SETON                                        29
     C                   ENDIF
     C                   SETOFF                                       30
     C     WFCYCD        IFEQ      *BLANKS
     C     WFBSRC        OREQ      *BLANKS
     C                   SETON                                        30
     C                   ENDIF
      *
      ** Check if CLE172 is installed
      *
     C                   EVAL      CLE172 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE172'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C                   IF        PRTCD <> *BLANKS  AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C/COPY ZACPYSRC,DBFIELDS
     C                   EVAL      DBFILE =  'SCSARDPD'                         *************
     C                   EVAL      DBKEY  =  PSARD                              * DBERR 001 *
     C                   EVAL      DBASE  =  001                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CLE172 = 'Y'
     C                   ENDIF
      *
      ** Access General Ledger details
      *
     C                   CALLB     'AOGELRR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDGELRPD'                         *************
     C                   EVAL      DBKEY  =  '*FIRST'                           * DBERR 002 *
     C                   EVAL      DBASE  =  002                                *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Dealing Details
      *
     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      DLBNDCSP =  '.'
     C                   ENDIF
      *
      ** Access Base Rate Details
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WFCYCD        PKEY1
     C                   PARM      WFBSRC        PKEY2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      BBABSRC       WFBSRC
     C                   ENDIF
      *
      ** Acess Loan Details defaulting
      *
     C     WKCLOANR      CHAIN     LECLIPL2      LECLOAN              20
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RSTFLDS  - Subroutine for resetting work fields              *
      *                                                               *
      *****************************************************************
     C     RSTFLDS       BEGSR
      *
     C                   MOVE      *BLANKS       ArrayInp
     C                   Z-ADD     Idx           Ix                             Store index
      *
      ** Reset OK Fields
      *
     C                   EVAL      DDBLRTOK = *BLANK
     C                   EVAL      DDAVOPOK = *BLANK
     C                   EVAL      DDLBDYOK = *BLANK
     C                   EVAL      DDLODYOK = *BLANK
     C                   EVAL      DDWGHTOK = *BLANK
     C                   EVAL      DDBADJOK = *BLANK
     C                   EVAL      DDPDLYOK = *BLANK
     C                   EVAL      DDNVOPOK = *BLANK
     C                   EVAL      DDNBDYOK = *BLANK
     C                   EVAL      DDNODYOK = *BLANK
     C                   EVAL      DDNGHTOK = *BLANK
     C                   EVAL      DDNADJOK = *BLANK
     C                   EVAL      DDNDLYOK = *BLANK
     C                   EVAL      DDCARTOK = *BLANK
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDBLRT - Default backward-looking rate                       *
      *****************************************************************
     C     SDBLRT        BEGSR
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   MOVE      HBLRT         DDBLRT                          Default from
     C                   ELSE                                                    CLOANCL
     C                   MOVE      'N'           DDBLRT
     C                   ENDIF
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     *IN30         ANDEQ     *OFF
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     ApiName       OREQ      'LERI'
     C     HBRTT         ANDNE     WFBSRC
      *
     C                   MOVE      BBABLRT       DDBLRT                          Default from
      *                                                                          SDBSRTPD
     C                   ENDIF
      *
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBLRT - Validate backward-looking rate                      *
      *****************************************************************
     C     SRBLRT        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     ApiName       IFEQ      'CLIP'
      *
     C     DDBLRT        IFEQ      'Y'
     C     BKALDI        ANDEQ     'Y'
      *
      ** Accrue on Last Day is Y and Rate is Backward-Looking Rate
      *
     C                   MOVE      'N'           DDBLRTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRTT'      FldNamXAr(Idx)
     C                   MOVEL     '5049454'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF                                                  END CLE172
      *
     C     DDBLRTOK      IFNE      'N'
     C                   MOVE      DDBLRT        VBLRT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDAVOP - Default averaging option                            *
      *****************************************************************
     C     SDAVOP        BEGSR
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   MOVE      HAVOP         DDAVOP                          Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     ApiName       ANDEQ     'CLIP'
     C     DDAVOP        ANDEQ     *BLANKS
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
     C                   MOVE      BBAAVOP       DDAVOP                          Default from
      *                                                                          SDBSRTPD
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAVOP - Validate averaging option                           *
      *****************************************************************
     C     SRAVOP        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDAVOP        IFNE      *BLANKS                                      Not blank
      *
     C     DDAVOP        IFNE      '1'
     C     DDAVOP        ANDNE     '2'
     C     DDAVOP        ANDNE     '3'
     C     DDAVOP        ANDNE     '4'
      *
      ** Averaging Option value is invalid
      *
     C                   MOVE      'N'           DDAVOPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAVOP'      FldNamXAr(Idx)
     C                   MOVEL     '5049403'     MsgIdXAr(Idx)
     C                   ELSE                                                    If valid
      *
     C     VBLRT         IFNE      'Y'
      *
      ** Backward-Looking Rate is N and Averaging Option is not blank
      *
     C                   MOVE      'N'           DDAVOPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAVOP'      FldNamXAr(Idx)
     C                   MOVEL     '5049405'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END valid
     C                   ENDIF                                                  END not blank
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDAVOPOK      IFNE      'N'
     C                   MOVE      DDAVOP        VAVOP
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDLBDY - Default lookback days for settlement                *
      *****************************************************************
     C     SDLBDY        BEGSR
      *
     C                   Z-ADD     0             WDAY                           Reset WDAY
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   Z-ADD     HLBDY         WDAY                            Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     DDLBDY        ANDEQ     *BLANKS
     C     ApiName       ANDEQ     'CLIP'
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
      *
     C                   Z-ADD     BBALBDY       WDAY                            Default from
     C                                                                           SDBSRTPD
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLBDY - Validate lookback days for settlement               *
      *****************************************************************
     C     SRLBDY        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDLBDY        IFNE      *BLANKS                                      Not blank
      *
     C                   MOVEL     DDLBDY        #1TESTN
     C     #1TESTN       SCAN      NumBlank      #1CHARPOS
     C                   MOVE      DDLBDY        #2TESTN
     C     #2TESTN       SCAN      NumBlank      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO                                         Not numeric
     C     #2CHARPOS     OREQ      *ZERO
      *
      ** Lookback Days for Settlement is not numeric
      *
     C                   MOVE      'N'           DDLBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049423'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C     #2TESTN       IFEQ      *BLANK                                        Right align
     C                   MOVE      #1TESTN       WDAY
     C                   ELSE
     C                   MOVE      DDLBDY        WDAY
     C                   ENDIF
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Lookback Days is not 0
      *
     C                   MOVE      'N'           DDLBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049420'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END not blank
     C                   ENDIF                                                  END CLE172
      *
     C     DDLBDYOK      IFNE      'N'
     C                   Z-ADD     WDAY          VLBDY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDLODY - Default lockout days                                *
      *****************************************************************
     C     SDLODY        BEGSR
      *
     C                   Z-ADD     0             WDAY                           Reset WDAY
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   Z-ADD     HLODY         WDAY                            Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     DDLODY        ANDEQ     *BLANKS
     C     ApiName       ANDEQ     'CLIP'
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
      *
     C                   Z-ADD     BBALODY       WDAY                            Default from
      *                                                                          SDBSRTPD
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRLODY - Validate lockout days                               *
      *****************************************************************
     C     SRLODY        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDLODY        IFNE      *BLANKS                                      Not blank
      *
     C                   MOVEL     DDLODY        #1TESTN
     C     #1TESTN       SCAN      NumBlank      #1CHARPOS
     C                   MOVE      DDLODY        #2TESTN
     C     #2TESTN       SCAN      NumBlank      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO                                         Not numeric
     C     #2CHARPOS     OREQ      *ZERO
      *
      ** Lockout Days is not numeric
      *
     C                   MOVE      'N'           DDLODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049424'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C     #2TESTN       IFEQ      *BLANK                                        Right align
     C                   MOVE      #1TESTN       WDAY
     C                   ELSE
     C                   MOVE      DDLODY        WDAY
     C                   ENDIF
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Lockout Days is not 0
      *
     C                   MOVE      'N'           DDLODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049421'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END not blank
     C                   ENDIF                                                  END CLE172
      *
     C     DDLODYOK      IFNE      'N'
     C                   Z-ADD     WDAY          VLODY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDWGHT - Default weight convention                           *
      *****************************************************************
     C     SDWGHT        BEGSR
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   MOVE      HWGHT         DDWGHT                          Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     ApiName       ANDEQ     'CLIP'
     C     DDWGHT        ANDEQ     *BLANKS
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
      *
     C     DDAVOP        IFEQ      '1'                                          And AVOP=1/2
     C     DDAVOP        OREQ      '2'
     C                   MOVE      BBAWGHT       DDWGHT                          Default from
      *                                                                          SDBSRTPD
     C                   ENDIF
      *
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRWGHT - Validate weight convention                          *
      *****************************************************************
     C     SRWGHT        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDWGHT        IFNE      *BLANKS                                      Not blank
      *
     C     DDWGHT        IFNE      '1'
     C     DDWGHT        ANDNE     '2'
      *
      ** Weight Convention value is invalid
      *
     C                   MOVE      'N'           DDWGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049408'     MsgIdXAr(Idx)
     C                   ELSE                                                    If valid
      *
     C     VBLRT         IFNE      'Y'
      *
      ** Backward-Looking Rate is N and Weight Convention is not blank
      *
     C                   MOVE      'N'           DDWGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049455'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     DDAVOP        IFNE      '1'
     C     DDAVOP        ANDNE     '2'
      *
      ** Averaging Option is not 1/2 and Weight Convention is not blank
      *
     C                   MOVE      'N'           DDWGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDWGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049453'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END valid
     C                   ENDIF                                                  END not blank
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDWGHTOK      IFNE      'N'
     C                   MOVE      DDWGHT        VWGHT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDBADJ - Default benchmark adjustment                        *
      *****************************************************************
     C     SDBADJ        BEGSR
      *
     C                   Z-ADD     0             WNumBadj                       Reset WNumBadj
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   Z-ADD     HBADJ         WNumBadj                        Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     DDBADJ        ANDEQ     *BLANKS
     C     ApiName       ANDEQ     'CLIP'
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
      *
     C                   Z-ADD     BBABADJ       WNumBadj                        Default from
      *                                                                          SDBSRTPD
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBADJ - Validate benchmark adjustment                       *
      *****************************************************************
     C     SRBADJ        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDBADJ        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
      *
      ** Benchmark Adjustment is not numeric
      *
     C                   MOVE      'N'           DDBADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C                   MOVE      *BLANK        WSign
     C     @@AMT         IFLT      0
     C                   Z-SUB     @@AMT         @@AMT
     C                   MOVE      '-'           WSign
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumBadj
     C     WSign         IFEQ      '-'
     C                   Z-SUB     WNumBadj      WNumBadj
     C                   ENDIF
     C                   ENDIF                                                   END numeric
      *
     C     VBLRT         IFNE      'Y'
     C     WNumBadj      ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Benchmark Adjustment is not 0
      *
     C                   MOVE      'N'           DDBADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDBADJOK      IFNE      'N'
     C                   Z-ADD     WNumBadj      VBADJ
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDPDLY - Default payment delay days                          *
      *****************************************************************
     C     SDPDLY        BEGSR
      *
     C                   Z-ADD     0             WDAY                           Reset WDAY
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   Z-ADD     HPDLY         WDAY                            Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     DDPDLY        ANDEQ     *BLANKS
     C     ApiName       ANDEQ     'CLIP'
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
      *
     C                   Z-ADD     BBAPDLY       WDAY                            Default from
      *                                                                          SDBSRTPD
     C                   ENDIF                                                  END CLE172
	  *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPDLY - Validate payment delay days                         *
      *****************************************************************
     C     SRPDLY        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDPDLY        IFNE      *BLANKS                                      Not blank
      *
     C                   MOVEL     DDPDLY        #1TESTN
     C     #1TESTN       SCAN      NUMBLANK      #1CHARPOS
     C                   MOVE      DDPDLY        #2TESTN
     C     #2TESTN       SCAN      NUMBLANK      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO                                         Not numeric
     C     #2CHARPOS     OREQ      *ZERO
      *
      ** Payment Delay Days is not numeric
      *
     C                   MOVE      'N'           DDPDLYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDLY'      FldNamXAr(Idx)
     C                   MOVEL     '5049425'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C     #2TESTN       IFEQ      *BLANK                                        Right align
     C                   MOVE      #1TESTN       WDAY
     C                   ELSE
     C                   MOVE      DDPDLY        WDAY
     C                   ENDIF
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Payment Delay Days is not 0
      *
     C                   MOVE      'N'           DDPDLYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPDLY'      FldNamXAr(Idx)
     C                   MOVEL     '5049422'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END blank
     C                   ENDIF                                                  END CLE172
      *
     C     DDPDLYOK      IFNE      'N'
     C                   Z-ADD     WDAY          VPDLY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDNVOP - Default next averaging option                       *
      *****************************************************************
     C     SDNVOP        BEGSR
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         IFEQ      *OFF                                         Not INSERT
     C                   MOVE      HNVOP         VNVOP                           Default from
     C                   ELSE                                                    CLOANCL
      *                                                                         If INSERT
     C                   MOVE      *BLANKS       VNVOP                          Default:blank
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ApiName = 'LERI' AND DDNVOP = *BLANKS
      *
      ** If Base Rate Code is unchanged, default from CLOANCL
      *
     C                   IF        WFBSRC = HNBRA
      *
     C                   IF        FreshRO = 'Y'
     C                   MOVE      HAVOP         DDNVOP
     C                   ELSE
     C                   MOVE      HNVOP         DDNVOP
     C                   ENDIF
      *
      ** If Base Rate Code was changed, default from SDBSRTPD
      *
     C                   ELSE
     C                   MOVE      BBAAVOP       DDNVOP
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNVOP - Validate new averaging option                       *
      *****************************************************************
     C     SRNVOP        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDNVOP        IFNE      *BLANKS                                      Not blank
      *
     C     DDNVOP        IFNE      '1'
     C     DDNVOP        ANDNE     '2'
     C     DDNVOP        ANDNE     '3'
     C     DDNVOP        ANDNE     '4'
      *
      ** Averaging Option value is invalid
      *
     C                   MOVE      'N'           DDNVOPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNVOP'      FldNamXAr(Idx)
     C                   MOVEL     '5049403'     MsgIdXAr(Idx)
     C                   ELSE                                                    If valid
      *
     C     VBLRT         IFNE      'Y'
      *
      ** Backward-Looking Rate is N and Averaging Option is not blank
      *
     C                   MOVE      'N'           DDNVOPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNVOP'      FldNamXAr(Idx)
     C                   MOVEL     '5049405'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END valid
     C                   ENDIF                                                  END not blank
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDNVOPOK      IFNE      'N'
     C                   MOVE      DDNVOP        VNVOP
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDNBDY - Default next lookback days for settlement          *
      *****************************************************************
     C     SDNBDY        BEGSR
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         IFEQ      *OFF                                         Not INSERT
     C                   MOVE      HNBDY         VNBDY                           Default from
     C                   ELSE                                                    CLOANCL
      *                                                                         If INSERT
     C                   Z-ADD     0             VNBDY                           Default: 0
     C                   ENDIF
     C                   ENDIF
      *
      ** Reset WDAY
      *
     C                   Z-ADD     0             WDAY
      *
     C                   IF        ApiName = 'LERI' AND DDNBDY = *BLANKS
      *
      ** If Base Rate Code is unchanged, default from CLOANCL
      *
     C                   IF        WFBSRC = HNBRA
      *
     C                   IF        FreshRO = 'Y'
     C                   MOVE      HLBDY         WDAY
     C                   ELSE
     C                   MOVE      HNBDY         WDAY
     C                   ENDIF
      *
      ** If Base Rate Code was changed, default from SDBSRTPD
      *
     C                   ELSE
     C                   MOVE      BBALBDY       WDAY
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNBDY - Validate new lookback days for settlement           *
      *****************************************************************
     C     SRNBDY        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDNBDY        IFNE      *BLANKS                                      Not blank
      *
     C                   MOVEL     DDNBDY        #1TESTN
     C     #1TESTN       SCAN      NumBlank      #1CHARPOS
     C                   MOVE      DDNBDY        #2TESTN
     C     #2TESTN       SCAN      NumBlank      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO                                         Not numeric
     C     #2CHARPOS     OREQ      *ZERO
      *
      ** Lookback Days for Settlement is not numeric
      *
     C                   MOVE      'N'           DDNBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049423'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C     #2TESTN       IFEQ      *BLANK                                        Right align
     C                   MOVE      #1TESTN       WDAY
     C                   ELSE
     C                   MOVE      DDNBDY        WDAY
     C                   ENDIF
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Lookback Days is not 0
      *
     C                   MOVE      'N'           DDNBDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNBDY'      FldNamXAr(Idx)
     C                   MOVEL     '5049420'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END not blank
     C                   ENDIF                                                  END CLE172
      *
     C     DDNBDYOK      IFNE      'N'
     C                   Z-ADD     WDAY          VNBDY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDNODY - Default next lockout days                          *
      *****************************************************************
     C     SDNODY        BEGSR
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         IFEQ      *OFF                                         Not INSERT
     C                   MOVE      HNODY         VNODY                           Default from
     C                   ELSE                                                    CLOANCL
      *                                                                         If INSERT
     C                   Z-ADD     0             VNODY                           Default: 0
     C                   ENDIF
     C                   ENDIF
      *
      ** Reset WDAY
      *
     C                   Z-ADD     0             WDAY
      *
     C                   IF        ApiName = 'LERI' AND DDNODY = *BLANKS
      *
      ** If Base Rate Code is unchanged, default from CLOANCL
      *
     C                   IF        WFBSRC = HNBRA
      *
     C                   IF        FreshRO = 'Y'
     C                   MOVE      HLODY         WDAY
     C                   ELSE
     C                   MOVE      HNODY         WDAY
     C                   ENDIF
      *
      ** If Base Rate Code was changed, default from SDBSRTPD
      *
     C                   ELSE
     C                   MOVE      BBALODY       WDAY
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNODY - Validate new lockout days                           *
      *****************************************************************
     C     SRNODY        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDNODY        IFNE      *BLANKS                                      Not blank
      *
     C                   MOVEL     DDNODY        #1TESTN
     C     #1TESTN       SCAN      NumBlank      #1CHARPOS
     C                   MOVE      DDNODY        #2TESTN
     C     #2TESTN       SCAN      NumBlank      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO                                         Not numeric
     C     #2CHARPOS     OREQ      *ZERO
      *
      ** Lockout Days is not numeric
      *
     C                   MOVE      'N'           DDNODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049424'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C     #2TESTN       IFEQ      *BLANK                                        Right align
     C                   MOVE      #1TESTN       WDAY
     C                   ELSE
     C                   MOVE      DDNODY        WDAY
     C                   ENDIF
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Lockout Days is not 0
      *
     C                   MOVE      'N'           DDNODYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNODY'      FldNamXAr(Idx)
     C                   MOVEL     '5049421'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END not blank
     C                   ENDIF                                                  END CLE172
      *
     C     DDNODYOK      IFNE      'N'
     C                   Z-ADD     WDAY          VNODY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDNGHT - Default next weight convention                      *
      *****************************************************************
     C     SDNGHT        BEGSR
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         IFEQ      *OFF                                         Not INSERT
     C                   MOVE      HNGHT         VNGHT                           Default from
     C                   ELSE                                                    CLOANCL
      *                                                                         If INSERT
     C                   MOVE      *BLANKS       VNGHT                          Default:blank
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ApiName = 'LERI' AND DDNGHT = *BLANKS
      *
      ** If Base Rate Code is unchanged, default from CLOANCL
      *
     C                   IF        WFBSRC = HNBRA
      *
     C                   IF        FreshRO = 'Y'
     C                   MOVE      HWGHT         DDNGHT
     C                   ELSE
     C                   MOVE      HNGHT         DDNGHT
     C                   ENDIF
      *
      ** If Base Rate Code was changed, default from SDBSRTPD
      *
     C                   ELSE
     C                   MOVE      BBAWGHT       DDNGHT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNGHT - Validate new weight convention                      *
      *****************************************************************
     C     SRNGHT        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDNGHT        IFNE      *BLANKS                                      Not blank
      *
     C     DDNGHT        IFNE      '1'
     C     DDNGHT        ANDNE     '2'
      *
      ** Weight Convention value is invalid
      *
     C                   MOVE      'N'           DDNGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049408'     MsgIdXAr(Idx)
     C                   ELSE                                                    If valid
      *
     C     VBLRT         IFNE      'Y'
      *
      ** Backward-Looking Rate is N and Weight Convention is not blank
      *
     C                   MOVE      'N'           DDNGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049455'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     DDNVOP        IFNE      '1'
     C     DDNVOP        ANDNE     '2'
      *
      ** Averaging Option is not 1/2 and Weight Convention is not blank
      *
     C                   MOVE      'N'           DDNGHTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNGHT'      FldNamXAr(Idx)
     C                   MOVEL     '5049453'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END valid
     C                   ENDIF                                                  END not blank
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDNGHTOK      IFNE      'N'
     C                   MOVE      DDNGHT        VNGHT
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDNADJ - Default next benchmark adjustment                   *
      *****************************************************************
     C     SDNADJ        BEGSR
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         IFEQ      *OFF                                         Not INSERT
     C                   MOVE      HNADJ         VNADJ                           Default from
     C                   ELSE                                                    CLOANCL
      *                                                                         If INSERT
     C                   Z-ADD     0             VNADJ                           Default: 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ApiName = 'LERI' AND DDNADJ = *BLANKS
      *
      ** If Base Rate Code is unchanged, default from CLOANCL
      *
     C                   IF        WFBSRC = HNBRA
      *
     C                   IF        FreshRO = 'Y'
     C                   MOVE      HBADJ         WNumNadj
     C                   ELSE
     C                   MOVE      HNADJ         WNumNadj
     C                   ENDIF
      *
      ** If Base Rate Code was changed, default from SDBSRTPD
      *
     C                   ELSE
     C                   MOVE      BBABADJ       WNumNadj
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNADJ - Validate new benchmark adjustment                   *
      *****************************************************************
     C     SRNADJ        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDNADJ        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
      *
      ** Benchmark Adjustment is not numeric
      *
     C                   MOVE      'N'           DDNADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049426'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C                   MOVE      *BLANK        WSign
     C     @@AMT         IFLT      0
     C                   Z-SUB     @@AMT         @@AMT
     C                   MOVE      '-'           WSign
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumNadj
     C     WSign         IFEQ      '-'
     C                   Z-SUB     WNumNadj      WNumNadj
     C                   ENDIF
     C                   ENDIF                                                   END numeric
      *
     C     VBLRT         IFNE      'Y'
     C     WNumNadj      ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Benchmark Adjustment is not 0
      *
     C                   MOVE      'N'           DDNADJOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNADJ'      FldNamXAr(Idx)
     C                   MOVEL     '5049401'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDNADJOK      IFNE      'N'
     C                   Z-ADD     WNumNadj      VNADJ
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDNDLY - Default next payment delay days                     *
      *****************************************************************
     C     SDNDLY        BEGSR
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN29         IFEQ      *OFF                                         Not INSERT
     C                   MOVE      HNDLY         VNDLY                           Default from
     C                   ELSE                                                    CLOANCL
      *                                                                         If INSERT
     C                   Z-ADD     0             VNDLY                           Default: 0
     C                   ENDIF
     C                   ENDIF
      *
      ** Reset WDAY
      *
     C                   Z-ADD     0             WDAY
      *
     C                   IF        ApiName = 'LERI' AND DDNDLY = *BLANKS
      *
      ** If Base Rate Code is unchanged, default from CLOANCL
      *
     C                   IF        WFBSRC = HNBRA
      *
     C                   IF        FreshRO = 'Y'
     C                   MOVE      HPDLY         WDAY
     C                   ELSE
     C                   MOVE      HNDLY         WDAY
     C                   ENDIF
      *
      ** If Base Rate Code was changed, default from SDBSRTPD
      *
     C                   ELSE
     C                   MOVE      BBAPDLY       WDAY
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRNDLY - Validate new payment delay days                     *
      *****************************************************************
     C     SRNDLY        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     DDNDLY        IFNE      *BLANKS                                      Not blank
      *
     C                   MOVEL     DDNDLY        #1TESTN
     C     #1TESTN       SCAN      NUMBLANK      #1CHARPOS
     C                   MOVE      DDNDLY        #2TESTN
     C     #2TESTN       SCAN      NUMBLANK      #2CHARPOS
      *
     C     #1CHARPOS     IFEQ      *ZERO                                         Not numeric
     C     #2CHARPOS     OREQ      *ZERO
      *
      ** Payment Delay Days is not numeric
      *
     C                   MOVE      'N'           DDNDLYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDLY'      FldNamXAr(Idx)
     C                   MOVEL     '5049425'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C     #2TESTN       IFEQ      *BLANK                                        Right align
     C                   MOVE      #1TESTN       WDAY
     C                   ELSE
     C                   MOVE      DDNDLY        WDAY
     C                   ENDIF
      *
     C     VBLRT         IFNE      'Y'
     C     WDAY          ANDNE     *ZEROS
      *
      ** Backward-Looking Rate is N and Payment Delay Days is not 0
      *
     C                   MOVE      'N'           DDNDLYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDNDLY'      FldNamXAr(Idx)
     C                   MOVEL     '5049422'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                   END numeric
     C                   ENDIF                                                  END blank
     C                   ENDIF                                                  END CLE172
      *
     C     DDNDLYOK      IFNE      'N'
     C                   Z-ADD     WDAY          VNDLY
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDCART - Default compounded/average rate                     *
      *****************************************************************
     C     SDCART        BEGSR
      *
     C                   Z-ADD     0             WNumCart                       Reset WNumCart
      *
     C     *IN29         IFEQ      *OFF                                         If LOAN EXIST
     C                   Z-ADD     HCART         WNumCart                        Default from
     C                   ENDIF                                                   CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     DDCART        ANDEQ     *BLANKS
     C     ApiName       ANDEQ     'CLIP'
     C     *IN29         ANDEQ     *ON                                          And INSERT
     C     *IN30         ANDEQ     *OFF
	  *
     C                   Z-ADD     0             WNumCart                        Default: 0
      *
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCART - Validate compounded/average rate                    *
      *****************************************************************
     C     SRCART        BEGSR
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDCART        @@ALPH
     C                   CALLB     'ZA0841'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH                         Display field
     C                   PARM      8             @@IDP                          no.of dec.plcs
     C                   PARM      5             @@IINT                         no.of integers
     C                   PARM      'N'           @@MTID                         Mil/Thou
     C                   PARM      *ZERO         @@ERCD                         Error code
     C                   PARM      *ZERO         @@AMT                          File field
     C                   PARM                    DLBNDCSP
      *
     C     @@ERCD        IFNE      0                                             Not numeric
      *
      ** Compounded/Average rate is not numeric
      *
     C                   MOVE      'N'           DDCARTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCART'      FldNamXAr(Idx)
     C                   MOVEL     '5049458'     MsgIdXAr(Idx)
     C                   ELSE                                                    If numeric
      *
     C                   MOVE      *BLANK        WSign
     C     @@AMT         IFLT      0
     C                   Z-SUB     @@AMT         @@AMT
     C                   MOVE      '-'           WSign
     C                   ENDIF
     C                   MOVE      @@AMT         @@ALPH
     C                   MOVE      @@ALPH        WNumCart
     C     WSign         IFEQ      '-'
     C                   Z-SUB     WNumCart      WNumCart
     C                   ENDIF
     C                   ENDIF                                                   END numeric
      *
     C     VBLRT         IFNE      'Y'
     C     WNumCart      ANDNE     *ZEROS
      *
      ** Backward-looking rate is N and Compounded/Average rate is not 0
      *
     C                   MOVE      'N'           DDCARTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCART'      FldNamXAr(Idx)
     C                   MOVEL     '5049459'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF                                                  END CLE172
      *
     C     DDCARTOK      IFNE      'N'
     C                   Z-ADD     WNumCart      VCART
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDBRAC - Default base rate for accrual                       *
      *****************************************************************
     C     SDBRAC        BEGSR
      *
     C                   MOVE      *BLANKS       VBRAC                          Default:blank
     C     *IN29         IFEQ      *OFF
     C                   MOVE      HBRAC         VBRAC                          Default from
     C                   ENDIF                                                  CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
      *
     C     ApiName       IFEQ      'CLIP'
     C     *IN30         ANDEQ     *OFF
     C                   MOVE      BBABRAC       VBRAC                           Default from
     C                   ENDIF                                                   SDBSRTPD
      *
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDLBAC - Default Lookback Days for Accrual                   *
      *****************************************************************
     C     SDLBAC        BEGSR
      *
     C                   Z-ADD     0             VLBAC                          Default: 0
     C     *IN29         IFEQ      *OFF
     C                   MOVE      HLBAC         VLBAC                          Default from
     C                   ENDIF                                                  CLOANCL
      *
     C     CLE172        IFEQ      'Y'                                          CLE172=ON
     C     *IN29         ANDEQ     *ON
     C     *IN30         ANDEQ     *OFF
     C     VBRAC         ANDNE     *ZEROS
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WFCYCD        PKEY1
     C                   PARM      BBABRAC       PKEY2
     C     SDBRACDS      PARM      SDBRACDS      DSSDY
     C     PRTCD         IFEQ      *BLANKS                                      If found BRAC
     C                   Z-ADD     ZBALBDY       VLBAC                          Default from
     C                   ENDIF                                                   ref. LBDY
      *
     C                   ENDIF                                                  END CLE172
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SDPIAD - Default principal interest control date            *
      *****************************************************************
     C     SDPIAD        BEGSR
      *
     C     *IN29         IFEQ      *OFF
     C                   MOVE      HPIAD         VPIAD
     C                   ELSE
     C                   MOVE      0             VPIAD
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRFRSHRO - Subroutine for determining if the transaction is  *
      *             the first Rollover Event for the Loan Reference   *
      *                                                               *
      *****************************************************************
     C     SRFRSHRO      BEGSR
      *
      ** Since NVOP is a mandatory field for backward-looking rates,
      ** it is used to determine if a rollover event exists for the loan
      *
     C                   IF        HNVOP = *BLANKS
     C                   EVAL      FreshRO = 'Y'
     C                   ELSE
     C                   EVAL      FreshRO = 'N'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2020
