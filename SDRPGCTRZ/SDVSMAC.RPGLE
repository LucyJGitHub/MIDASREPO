     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Settlement Account')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Service Fees Validation       *
      *                                                               *
      *  SDVSMAC - Validate Settlement Account
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Service Fees amendments must not be                 *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define work field Customer
     D  WUCUST         S              6    Inz(*Blanks)
      ** Define work field SAR SO1423
     D  WUKKST         S              1    Inz(*Blanks)
      ** Define work field Access Pgm Return Code
     D  WUAPRC         S              7    Inz(*Blanks)
      ** Define work field Access obj dummy DS (76)
     D  WUFDY          S             76    Inz(*Blanks)
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** 800 byte DS for incoming data from Access Program
     D D@ACCT        E DS                  EXTNAME(ACCNTAB)
      ** EXTERNAL DS FOR CURRENCY DETAILS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Define work field Validate A/C, Cur., Brnch
     D WUVACB          S              1    Inz(*Blanks)
      ** Define work field SAR S01464
     D  WURTST         S              1    Inz(*Blanks)
      ** Define flag for 'Message has been sent'
     D  WUMHBS         S              1    Inz('N')
      ** Define work field Account Sequence No.  WRK
     D  WUACSW         S              2    Inz(*Blank)
      ** Define work field Retail
     D  WURETL         S             10    Inz(*Blank)
      ** Define work field Account Code
     D  WUACCD         S             10    Inz(*Blank)
      ** work field Currency Code
     D  WUCYCD         S              3    Inz(*Blank)
      ** Define work field Branch code
     D  WUBRCD         S              3    Inz(*Blank)
      ** Define work field Account exists
     D  WUACEX         S              1    Inz(*Blank)
      ** Define work field Saved currency code
     D  WUSCUR         S              3    Inz(*Blank)
      ** Define work field Account status
     D  WUASTT         S              1    Inz(*Blank)
      ** Define work field Saved Branch code
     D  WUSBRH         S              3    Inz(*Blank)
      **
     D  CSD008         S              1A   Inz(*Blank)
     D  WUSARN         S              6A
     D  Y0CX01         S              1A
     D  @KEY           S              3A
     D  W0RTN          S              7A
     D  PRTCD          S              7A
     D  POPTN          S              7A
     D  #1CUSA         S             12A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDSMAC          S             18A
     D DDSBCH          S              3A
     D DDSCCY          S              3A
     D DDNAIN          S              1A
     D DDHMIN          S              1A
     D DDSMACOK        S              1A
     D DDSBCHOK        S              1A
     D DDSCCYOK        S              1A
     D SFSBCH          S              3A
 
      ** Parameters for AOSARDR0
     D WQ0006          S              7A
     D WQ0007          S              7A
     D WQ0008          S              6A
     D WQ0009          S             76A
     D WQ0010          S              7A
     D WQ0011          S              7A
     D WQ0012          S              6A
     D WQ0013          S             76A
 
      ** Parameters for AOACCTR0
     D UUAPRC          S              7A
     D UUAPOP          S              7A
     D UUACID          S             10A
     D UUCUST          S              6A
     D UUCYCD          S              3A
     D UUACNO          S             10A
     D UUACSN          S              2A
     D UUBRCD          S              3A
 
      ** Parameters for AOBRCHR1
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@BRCA          S              3A
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
     C                   Z-ADD     0             WIdx
 
      ** Validation
      ** Settlement account
      ** Settlement Account is Blank
     C     DDSMAC        IFEQ      *BLANK
      ** Validate A/C, Cur., Brnch is Yes
     C     WUVACB        IFEQ      'Y'
     C     CSD008        IFEQ      'N'
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC'
     C                   EVAL      MsgIdXAr(Idx) = 'USR1979'
 
     C                   ENDIF
 
     C                   ELSE
      ** SAR S01464 is Present
     C     WURTST        IFEQ      'Y'
     C     CSD008        OREQ      'Y'
      ** Message has been sent is No
     C     WUMHBS        IFEQ      'N'
      **  - (c1 AND c2) OR (c1 OR c2)
      **   |- c1    : Settlement Currency is Entered
      **   |- c2    : Settlement Branch Two is Entered
      **   '-
     C                   MOVEL     '0'           Y0CX01
     C     DDSCCY        IFNE      *BLANK
     C     DDSBCH        ORNE      *BLANK
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2282'
 
     C                   MOVEL     'Y'           WUMHBS
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE
      **      |- c1    : Validate A/C, Cur., Brnch is No
      **      |- c2    : SAR S01464 is Not present
     C                   MOVEL     '0'           Y0CX01
     C     WUVACB        IFEQ      'N'
     C     WURTST        IFEQ      'N'
     C     CSD008        ANDEQ     'N'
     C                   MOVEL     '1'           Y0CX01
     C                   END
     C                   END
     C     Y0CX01        IFEQ      '1'
      ** Setup message data for message
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1996'
      ** Send message 'Stl Account must be blank'
     C                   ELSE
 
      ** Split Account Settlement into Account code and Account Sequence
      ** Number
     C                   MOVE      DDSMAC        #1CUSA
     C                   MOVEL     #1CUSA        WUACCD
     C                   MOVE      DDSMAC        WUACSW
      ** Setup parameters for call to AOACCTR0.
      ** Account Sequence No.   is Blank
     C     WUACSW        IFEQ      *BLANK
      ** Retail account number processing.
     C                   MOVEL     DDSMAC        WURETL
     C                   MOVEL     *BLANK        WUACCD
     C                   MOVEL     *BLANK        WUCYCD
     C                   MOVEL     *BLANK        WUBRCD
     C                   MOVEL     *BLANK        WUACSW
      ** Settlement branch
      ** Check if Multi-branching Indicator is off:
     C     MBIN          IFNE      'Y'
      ** In single branch environment, get the branch from SDBANKPD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     BJSBRC        SFSBCH
     C                   END
     C                   ELSE
      ** Non-retail account number processing.
     C                   MOVEL     *BLANK        WURETL
     C                   MOVEL     DDSMAC        WUCUST
     C                   MOVEL     DDSCCY        WUCYCD
      ** Settlement branch
      ** Check if Multi-branching Indicator is on
     C     MBIN          IFEQ      'Y'
     C                   MOVEL     DDSBCH        WUBRCD
     C                   ELSE
      ** In single branch environment, get the branch from SDBANKPD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BJSBRC        WUBRCD
     C                   MOVEL     BJSBRC        SFSBCH
     C                   END
     C                   END
     C                   MOVEL     *BLANK        W0RTN
      ** Access Accounts file - Customer Fees Detail  *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
     C                   CALL      'AOACCTR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC
     C                   PARM      '*KEY'        UUAPOP
     C                   PARM      WURETL        UUACID
     C                   PARM      WUCUST        UUCUST
     C                   PARM      WUCYCD        UUCYCD
     C                   PARM      WUACCD        UUACNO
     C                   PARM      WUACSW        UUACSN
     C                   PARM      WUBRCD        UUBRCD
     C     D@ACCT        PARM      *BLANK        DSSDY
 
      ** Pass back A/c Status, Currency Code and Branch Code
     C                   MOVE      ACST          WUASTT
     C                   MOVE      CCY           WUSCUR
     C                   MOVE      BRCA          WUSBRH
      ** Check return code
      ** Access Pgm Return Code is *Normal
     C     WUAPRC        IFEQ      *BLANK
      ** Account status is Closed
     C     WUASTT        IFEQ      'C'
 
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2012'
     C                   ELSE
     C                   MOVEL     'Y'           WUACEX
     C                   END
     C                   ELSE
 
      ** Send message 'Settlement A/C invalid'
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1989'
 
     C                   MOVEL     'N'           WUACEX
     C                   END
      ** Call AOACCTR0 with *FREE to close files
      ** Access Accounts file - Customer Fees Detail  *
      ** Call to Access Program - AOACCTR0 Check Account Number
      ** Access Account Details file for the file fields
     C                   CALL      'AOACCTR0'
     C     WUAPRC        PARM      WUAPRC        UUAPRC
     C                   PARM      '*KEY'        UUAPOP
     C                   PARM      WURETL        UUACID
     C                   PARM      WUCUST        UUCUST
     C                   PARM      WUCYCD        UUCYCD
     C                   PARM      WUACCD        UUACNO
     C                   PARM      WUACSW        UUACSN
     C                   PARM      WUBRCD        UUBRCD
     C     D@ACCT        PARM      *BLANK        DSSDY
 
     C**   Pass back A/c Status, Currency Code and Branch Code
     C                   MOVE      ACST          WUASTT
     C                   MOVE      CCY           WUSCUR
     C                   MOVE      BRCA          WUSBRH
 
     C                   ENDIF
     C                   ENDIF
      ** Settlement Currency
      **  Settlement Currency is Blank
     C     DDSCCY        IFEQ      *BLANK
      **  Validate A/C, Cur., Brnch is Yes
     C     WUVACB        IFEQ      'Y'
     C     CSD008        IFEQ      'N'
 
      ** Send message 'Settlement Curr. is reqd'
     C                   EVAL      DDSMACOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSMAC   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1980'
     C                   ENDIF
 
     C                   ELSE
      ** SAR S01464 is Present
     C     WURTST        IFEQ      'Y'
     C     CSD008        OREQ      'Y'
      ** Message has been sent is No
     C     WUMHBS        IFEQ      'N'
      ** - (c1 AND c2) OR (c1 OR c2)
      **  |- c1    : Settlement Account is Entered
      **  |- c2    : Settlement Branch Two is Entered
      **  '-
     C                   MOVEL     '0'           Y0CX01
     C     DDSMAC        IFNE      *BLANK
     C     DDSBCH        ORNE      *BLANK
      ** Send message 'S. fields must be entered'
     C                   EVAL      DDSCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSCCY   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2282'
     C                   MOVEL     'Y'           WUMHBS
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE
 
      ** - c1 AND c2
      **  |- c1    : Validate A/C, Cur., Brnch is No
      **  |- c2    : SAR S01464 is Not present
      **  '-
     C                   MOVEL     '0'           Y0CX01
     C     WUVACB        IFEQ      'N'
     C     WURTST        IFEQ      'N'
     C     CSD008        ANDEQ     'N'
     C                   MOVEL     '1'           Y0CX01
     C                   END
     C                   END
     C     Y0CX01        IFEQ      '1'
 
      ** Send message 'Currency must be blank'
     C                   EVAL      DDSCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSCCY   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1995'
 
     C                   ELSE
 
     C                   MOVEL     DDSCCY        WUCYCD
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      DDSCCY        @KEY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Is it a valid Currency ?
     C     @RTCD         IFNE      *BLANKS
      ** Send message 'Invalid settlement CURR'
     C                   EVAL      DDSCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSCCY   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1977'
     C                   END
     C                   END
 
      ** Does account exist?
      ** Account exists is YES
     C     WUACEX        IFEQ      'Y'
      ** Settlement Currency NE Saved currency code
     C     DDSCCY        IFNE      WUSCUR
      ** Send message 'Invalid currency for A/C'
     C                   EVAL      DDSCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSCCY   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2013'
     C                   END
     C                   END
     C                   END
      ** Validate Settlement branch, only in Multi-branched environment
      ** Multi-branching Indicator is Multi-branched
     C     MBIN          IFEQ      'Y'
      ** Settlement Branch Two is Blank
     C     DDSBCH        IFEQ      *BLANK
      ** Validate A/C, Cur., Brnch is Yes
     C     WUVACB        IFEQ      'Y'
     C     CSD008        IFEQ      'N'
      ** Send message 'Settlement Branch is reqd'
     C                   EVAL      DDSBCHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSBCH   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1981'
     C                   ENDIF
 
     C                   ELSE
      ** SAR S01464 is Present
     C     WURTST        IFEQ      'Y'
     C     CSD008        OREQ      'Y'
     C     WUMHBS        IFEQ      'N'
      ** - (c1 AND c2) OR (c1 OR c2)
      **   |- c1    : Settlement Account is Entered
      **   |- c2    : Settlement Currency is Entered
      **   '-
     C                   MOVEL     '0'           Y0CX01
     C     DDSMAC        IFNE      *BLANK
     C     DDSCCY        ORNE      *BLANK
      ** Send message 'S. fields must be entered'
     C                   EVAL      DDSBCHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSBCH   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2282'
     C                   MOVEL     'Y'           WUMHBS
     C                   END
     C                   END
     C                   END
     C                   END
     C                   ELSE
      ** - c1 AND c2
      **   |- c1    : Validate A/C, Cur., Brnch is No
      **   |- c2    : SAR S01464 is Not present
      **   '-
     C                   MOVEL     '0'           Y0CX01
     C     WUVACB        IFEQ      'N'
     C     WURTST        IFEQ      'N'
     C     CSD008        ANDEQ     'N'
     C                   MOVEL     '1'           Y0CX01
     C                   END
     C                   END
     C     Y0CX01        IFEQ      '1'
      ** Send message 'Branch must be blank'
     C                   EVAL      DDSBCHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSBCH   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR2282'
 
     C                   ELSE
 
      ** Retrieve branch codes - Branch Codes *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C     DDSBCH        PARM      DDSBCH        P@BRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
      ** Is it a valid Branch code ?
     C     P@RTCD        IFNE      *Blank
      ** Send message 'Invalid Settlement Branch'
     C                   EVAL      DDSBCHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSBCH   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1978'
 
     C                   END
 
      ** Account exists is YES
     C     WUACEX        IFEQ      'Y'
 
      ** Settlement Branch Two NE Saved Branch code
     C     DDSBCH        IFNE      WUSBRH
      ** Send message 'Branch not valid for A/C'
     C                   EVAL      DDSBCHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSBCH   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1978'
 
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Other parms
      ** Field(s) requiring validation
      ** Settlement Account
     C                   PARM                    DDSMAC
      ** Settlement Branch
     C                   PARM                    DDSBCH
      ** Settlement Currency
     C                   PARM                    DDSCCY
      ** Numbered a/c indicator
     C                   PARM                    DDNAIN
      ** Hold Mail indicator
     C                   PARM                    DDHMIN
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     ** Settlement Account -       OK
     C                   PARM                    DDSMACOK
     ** Settlement Branch -        OK
     C                   PARM                    DDSBCHOK
     ** Settlement Currency -      OK
     C                   PARM                    DDSCCYOK
     ** Settlement Branch
     C                   PARM                    SFSBCH
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
      ** Call access program AOSARDR0- determine if CSD008 is installed
 
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      '       '     WQ0006
     C                   PARM      '*VERIFY'     WQ0007
     C     WUSARN        PARM      'CSD008'      WQ0008
     C                   PARM      WUFDY         WQ0009
 
     C     *IN90         IFEQ      '1'
     C                   EVAL      DBKEY  = 'AOSARDR0'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBASE  =  002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WUAPRC <> *BLANKS AND
     C                             WUAPRC <> '*NRF   '
     C                   EVAL      DBKEY  = 'CSD008'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** CSD008 is installed
     C     WQ0006        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD008
     C                   ELSE
     C                   MOVE      'N'           CSD008
     C                   ENDIF
 
      ** Numbered A/c Indicator is Yes
     C     DDNAIN        IFEQ      'Y'
     C                   MOVEL     'Y'           WUVACB
     C                   END
      ** Hold Mail Indicator is Yes
     C     DDHMIN        IFEQ      'Y'
     C                   MOVEL     'Y'           WUVACB
     C                   END
      ** Check S01464
     C                   MOVEL     'S01464'      WUSARN
      ** SAR switched on check - Standard Functions *
     C                   CALL      'AOSARDR0'                           90
     C     WUAPRC        PARM      WUAPRC        WQ0010
     C                   PARM      '*VERIFY'     WQ0011
     C     WUSARN        PARM      WUSARN        WQ0012
     C                   PARM      WUFDY         WQ0013
 
     C     *IN90         IFEQ      '1'
     C                   EVAL      DBKEY  = 'AOSARDR0'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBASE  =  003
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     WUAPRC        IFEQ      '*EMPTY'
     C     WUAPRC        OREQ      '*EOF'
     C     WUAPRC        OREQ      '*ERROR'
     C     WUAPRC        OREQ      '*CLOSE'
     C     WUAPRC        OREQ      '*OPEN'
     C     WUAPRC        OREQ      '*NRF'
     C                   MOVEL     'N'           WURTST
     C                   ELSE
     C                   MOVEL     'Y'           WURTST
     C                   END
      ** Get Rundate - Rundate *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
