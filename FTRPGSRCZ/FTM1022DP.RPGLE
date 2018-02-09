     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Display one CCT detail screen 1')             *
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1022DP - Display one CCT detail : screen 1                     *
      *                                                                    *
      *  Function:  This module display a detail of a Customer Credit      *
      *             Transfer                                               *
      *                                                                    *
      *  (c) Finastra International Limited 2001                      *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW215             Date 06Apr15               *
      *                 MD022652           Date 07Oct13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01                    *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184060             Date 22Sep00                    *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00                    *
      *                 CFT007             Date 21Mar00                    *
      *                 CFT006  *CREATE    Date 22Nov99                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW215 - SWIFT Changes 2015                                       *
      *  MD022652 - Excluded Phase Processing                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes                                       *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)                 *
      *  188649 - Allow authorisation text pn screen                       *
      *  184060 - No transaction type code in detail screen                *
      *  178751 - Auto generation of references                            *
      *  CFT007 - BIC Database Plus                                        *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1022DDFCF   E             WORKSTN
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      *     28    Non display field indicator                              *
      *     29-53 Field Error - highlight screen fields                    *
      *     74    Protect CCtid                                            *
      *     70    Protect field transaction reference                      *
      *     71    Protect fields screen (Except CCt ID, File reference)    *
      *     72    Disable F5                                               *
      *     73    Disable F10                                              *
      *     78    To display appropriate title (incoming or outgoing)      *
      **********************************************************************
      * SUBROUTINE INDEX                                                   *
      *                                                                    *
      * *INZSR (for first call)                                            *
      * IniPgm : Initialisation  (called each time)                        *
      * Main : MAIN processing                                             *
      * HdlErrFlds : Handle Error fields                                   *
      * DftOutFlds : Default Output fields                                 *
      * RtnFields : Return fields                                          *
      * RtvFields : Retrieve fields                                        *
      *                                                                    *
      **********************************************************************
      /EJECT
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ AutomatiCally included D-specs       ¦
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatiCally included D-specs¦
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
 
      ** Number of screens
     D NBSCREENS       C                   Const(2)
 
      ** Fields on the screen
     D NBFIELDS        C                   Const(25)
 
      ** Place of the first indicator PC on the screen
     D*STARTPC*****    C                   Const(30)
     D STARTPC         C                   Const(29)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                CFT007
     D Scsard        E DS                  EXTNAME(SCSARDPD)                    CFT007
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS                                   CFT007
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
 
      * Fields of the screen
     D ScreenDtl     E DS                  EXTNAME(FT102DSPD)
 
      * Fields of the screen memorized
     D ScreenMem     E DS                  EXTNAME(FT102DSPD) PREFIX(M)
 
      ** Error Indicators
     D OkFields      E DS                  EXTNAME(FTE102S1PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** DATA STRUCTURES
      ** ---------------
 
     D STIME           DS
     D   SHH                          2
     D   SS1                          1    Inz(':')
     D   SMM                               Like(SHH)
     D   SS2                               Like(SS1) Inz(':')
     D   SSS                               Like(SHH)
 
     D WRunTime        DS
     D   Wtime                        6  0
     D   WtHH                         2  0 Overlay(Wtime:1)
     D   WtMM                         2  0 Overlay(Wtime:3)
     D   WtSS                         2  0 Overlay(Wtime:5)
 
      ** ARRAYS
      ** ------
 
      ** Array of subroutines stack
     D SrStack         S             15    Dim(30)
 
      ** Array of error indicators
     D @EI             S              1    DIM(NBFIELDS)
 
      ** Screens in error
     D ScreenErr       S              2    Dim(NBSCREENS)
 
 
      ** FLAGS
      ** -----
 
      ** First Reassignment
     D KeyStored       S              1
 
      ** INDEXS
      ** ------
     D q               S              2  0
     D i               S                   Like(q)
 
      ** WORKING VARIABLES
      ** -----------------
 
      ** Old CCT id
     D OldCctID        S                   Like(PCCTID)
 
      ** PARAMETERS
      ** ----------
      ** Parameters for AOCREPT
     D MsgID           S              7
     D Msgf            S             10    Inz('FTUSRMSG')
     D Msglib          S             10    Inz('*LIBL')
     D Msgdta          S            256
     D Msgrel          S              5
     D Msgq            S             10
     D Msgt            S              7
 
      ** Parameters for ZA0920
     D RtnCod          S             10
     D AmtN13D0        S             13  0
     D Qecn            S              1  0
     D BndCsp          S              1    Inz('.')
     D AmtA14          S             14
 
      ** Swift 2007                                                                           CSW207
     D CSW207          S              1                                                       CSW207
     D RetCd           S              7                                                       CSW207
                                                                                              CSW207
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatiCally: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Beg'         SrStack(q)
 
      **  Initialization
     C                   Exsr      IniPgm
 
      **  Main processing
     C                   Exsr      Main
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
      ** Return
     C     *INKC         Ifeq      '1'
     C                   Seton                                        LR
     C                   Endif
     C                   Return
      *
      *****************************************************************
      /EJECT
      **********************************************************************
      * INIT - Initialisation  (called each time)                          *
      **********************************************************************
     C     IniPgm        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'IniPgm'      SrStack(q)
                                                                                CFT007
      ** Access SAR details file to determine if CFT007                         CFT007
      ** (BIC Database +) is active                                             CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   PARM      *BLANKS       @Rtcd                          CFT007
     C                   PARM      '*VERIFY'     @Optn                          CFT007
     C                   PARM      'CFT007'      @Sard             6            CFT007
     C     SCSARD        PARM      SCSARD        Dsfdy                          CFT007
      *                                                                         CFT007
      ** Database Error                                                         CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd <> *BLANKS AND                         CFT007
     C                             @Rtcd <> '*NRF'                              CFT007
     C                   EVAL      DBFILE = 'SCSARDPD'                          CFT007
     C                   EVAL      DBASE = 999                                  CFT007
     C                   EVAL      DBKEY = 'CFT007'                             CFT007
     C                   EXSR      *PSSR                                        CFT007
     C                   ENDIF                                                  CFT007
      *                                                                         CFT007
     C                   IF        @Rtcd = *BLANKS                              CFT007
     C                   MOVEL     'Y'           CFT007            1            CFT007
     C                   ELSE                                                   CFT007
     C                   MOVEL     'N'           CFT007                         CFT007
     C                   ENDIF                                                  CFT007
      *                                                                                     MD022652
      ** Access SAR details file to determine if CFT050                                     MD022652
      ** SWIFTRef Directories Upload is active                                              MD022652
      *                                                                                     MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   PARM      *BLANKS       PRtcd             7                        MD022652
     C                   PARM      '*VERIFY'     POptn             7                        MD022652
     C                   PARM      'CFT050'      PSard             6                        MD022652
     C     SCSARD        PARM      SCSARD        Dsfdy                                      MD022652
      *                                                                                     MD022652
      ** Database Error                                                                     MD022652
      *                                                                                     MD022652
     C                   IF        PRtcd <> *BLANKS AND                                     MD022652
     C                             PRtcd <> '*NRF'                                          MD022652
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD022652
     C                   EVAL      DBASE = 999                                              MD022652
     C                   EVAL      DBKEY = 'CFT050'                                         MD022652
     C                   EXSR      *PSSR                                                    MD022652
     C                   ENDIF                                                              MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
     C                   IF        PRtcd = *BLANKS                                          MD022652
     C                   EVAL      CFT007 = 'Y'                                             MD022652
     C                   ENDIF                                                              MD022652
                                                                                            MD022652
 
      **  Retrieve and display time
     C                   Time                    Wtime
     C                   Move      WtHH          SHH
     C                   Move      WtMM          SMM
     C                   Move      WtSS          SSS
     C                   Move      ActionCode    SACTN
 
     C                   Z-ADD     1             c                 2 0
     C                   Z-ADD     STARTPC       e                 2 0
 
      ** Reset non display indicaotr
     C                   EVAL      *IN28 = *ON
 
      ** Reset previous hilighted fields
     C     c             Dougt     NBFIELDS
     C                   Movel     '0'           *IN(e)
     C                   Add       1             c
     C                   Add       1             e
     C                   Enddo
 
      ** Enable all the fields and function key
     C                   Movel     '0'           *IN70
     C                   Movel     '0'           *IN71
     C                   Movel     '0'           *IN72
     C                   Movel     '0'           *IN73
     C                   Movel     '0'           *IN74
 
      ** Title conditionning
      ** -------------------
      ** Test whether message type is incoming or outgoing and display
      ** appropriate header messages
     C                   If        @CctTyp = 'BO'
     C                   Eval      *IN78 = *ON
     C                   Else
     C                   Eval      *IN78 = *OFF
     C                   Endif
 
      ** Fields protection
      ** -----------------
     C                   Select
     C     ActionCode    Wheneq    'E'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN71
     C                   Movel     '1'           *IN74
 
     C     ActionCode    Wheneq    'X'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN71
     C                   Movel     '1'           *IN74
 
     C     ActionCode    Wheneq    'D'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN71
     C                   Movel     '1'           *IN74
 
     C     ActionCode    Wheneq    'A'
     C                   Movel     '1'           *IN70
     C                   Movel     '1'           *IN74
 
     C     ActionCode    Wheneq    'R'
      ***All*fields*are*protected,*except*CCT*for*transfer*ID*and*****          178751
      ***Transaction*Reference****************************************          178751
      ** All fields are protected, except CCT ID                                178751
     C                   Movel     '1'           *IN71
     C                   Movel     '1'           *IN70                          178751
 
     C     ActionCode    Wheneq    'I'
     C                   Movel     '1'           *IN74
 
     C                   Endsl
 
      ** Function key protection
      ** -----------------------
     C                   Select
     C     ActionCode    Wheneq    'E'
      ** F5 Disabled
      ** F10 Disabled
     C                   Movel     '1'           *IN72
     C                   Movel     '1'           *IN73
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
 
     C     ActionCode    Wheneq    'X'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
 
     C     ActionCode    Wheneq    'D'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
      ** Disable BIC search key                                                 CFT007
     C                   EVAL      *IN76 = *On                                  CFT007
     C                   EVAL      *IN82 = *Off                                 CFT007
 
     C     ActionCode    Wheneq    'A'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
      *                                                                         CFT007
      ** If BIC DB+ present, enable function keys                               CFT007
      *                                                                         CFT007
     C                   If        CFT007 = 'Y'                                 CFT007
     C                   Eval      *In82 = *On                                  CFT007
     C                   Eval      *In76 = *Off                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      *In82 = *Off                                 CFT007
     C                   Eval      *In76 = *On                                  CFT007
     C                   Endif                                                  CFT007
 
     C     ActionCode    Wheneq    'I'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
      *                                                                         CFT007
      ** If BIC DB+ present, enable function keys                               CFT007
      *                                                                         CFT007
     C                   If        CFT007 = 'Y'                                 CFT007
     C                   Eval      *In82 = *On                                  CFT007
     C                   Eval      *In76 = *Off                                 CFT007
     C                   Else                                                   CFT007
     C                   Eval      *In82 = *Off                                 CFT007
     C                   Eval      *In76 = *On                                  CFT007
     C                   Endif                                                  CFT007
 
     C                   Endsl
 
      ** Miscellaneous initialization depending of value of action code
      ** --------------------------------------------------------------
     C                   Select
     C     ActionCode    Wheneq    'R'
      ** We need to memorise the initial value of the key in order to
      ** know which transaction detail needs to be deleted in the former
      ** CCT
     C     KeyStored     Ifne      'Y'
     C                   Movel     'Y'           KeyStored
     C                   Movel     PCCTID        OldCctID
     C                   Endif
     C                   Other
     C                   Movel     'N'           KeyStored
     C                   Movel     *BLANK        OldCctID
     C                   Endsl
 
      **  Memorize fields in case of refresh (F5)
     C     MemoFields    Ifeq      'Y'
     C                   Movel     'N'           MemoFields
 
     C     ActionCode    Ifeq      'R'
     C                   Move      PCCTID        MPCCTID
     C                   Move      PTRNSID       MPTRNSID
     C                   Move      PFilRef       MPFilRef
     C                   Move      PCctTyp       MPCctTyp
     C                   Else
     C                   Move      PCCTID        MPCCTID
     C                   Move      PTRNSID       MPTRNSID
     C                   Move      PFilRef       MPFilRef
     C                   Move      PCctTyp       MPCctTyp
     C                   Move      PCctTyc       MPCctTyc                       184060
     C                   Move      PBENF1        MPBENF1
     C                   Move      PBENF2        MPBENF2
     C                   Move      PBENF3        MPBENF3
     C                   Move      PBENF4        MPBENF4
     C                   Move      PACCI35       MPACCI35
     C                   Move      PACCI11       MPACCI11
     C                   Move      PORDI35       MPORDI35
     C                   Move      PORDI11       MPORDI11
     C                   Move      PORDCU1       MPORDCU1
     C                   Move      PORDCU2       MPORDCU2
     C                   Move      PORDCU3       MPORDCU3
     C                   Move      PORDCU4       MPORDCU4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      MPORDCU5 = PORDCU5                                         CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      PCCTAMT       MPCCTAMT
     C                   Move      PCCTCCY       MPCCTCCY
     C                   Move      PCRDVDT       MPCRDVDT
     C                   Move      PXRATE        MPXRATE
     C                   Move      PXRATEO       MPXRATEO
     C                   Move      PORIGAM       MPORIGAM
     C                   Move      PORIGCY       MPORIGCY
     C                   Move      PPAYAMT       MPPAYAMT
     C                   Move      PPAYCCY       MPPAYCCY
     C                   Move      PCcyChg       MPccyChg
     C                   Endif
 
     C                   Endif
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * MAIN - MAIN processing                                             *
      **********************************************************************
     C     Main          Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'Main'        SrStack(q)
 
      ** Not handle error in fields in 'Enquire' mode
      ** and after a refresh
     C     ActionCode    Ifne      'E'
     C     Keypressed    andne     '05'
     C                   Exsr      HdlErrFlds
     C                   Endif
 
      ** Default output fields
     C                   Exsr      DftOutFlds
 
      ** Write message subfile, details and footer screen
     C                   Write     #MSGCTL
     C                   Write     FTM1022DF1
 
     C                   Read      FTM1022DF1                             99    *
 
      ** Clear message queue
     C                   Call      'ZA0250'
 
      ** KeyPress
     C                   Exsr      KeyPress
 
      ** Return fields from the screen
     C                   Exsr      RtnFields
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * RtnFields - Return fields                                          *
      **********************************************************************
     C     RtnFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtnFields'   SrStack(q)
 
     C                   Move      SCCTID        PCCTID
     C                   Move      STSEQNO       PTSEQNO                        178751
     C                   Move      STRNSID       PTRNSID
     C                   Move      SFilRef       PFilRef
     C                   Move      SCctTyp       PCcttyp
     C                   Move      SCctTyc       PCctTyc                        184060
     C                   Move      SBENF1        PBENF1
     C                   Move      SBENF2        PBENF2
     C                   Move      SBENF3        PBENF3
     C                   Move      SBENF4        PBENF4
     C                   Move      SBENF5        PBENF5
     C                   Move      SACCI35       PACCI35
     C                   Move      SACCI11       PACCI11
     C                   Move      SOINST        PORDI35
     C                   Move      SOINS1        PORDI11
     C                   Move      SORDCU1       PORDCU1
     C                   Move      SORDCU2       PORDCU2
     C                   Move      SORDCU3       PORDCU3
     C                   Move      SORDCU4       PORDCU4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      PORDCU5 = SORDCU5                                          CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      SCCTAMT       PCCTAMT
     C                   Move      SCCTCCY       PCCTCCY
     C                   Move      SCRDVDT       PCRDVDT
     C                   Move      SXRATE        PXRATE
     C                   Move      SXRATEO       PXRATEO
     C                   Move      SORIGAM       PORIGAM
     C                   Move      SORIGCY       PORIGCY
     C                   Move      SPAYAMT       PPAYAMT
     C                   Move      SPAYCCY       PPAYCCY
     C                   Move      SCcyChg       PCcyChg
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * HdlErrFlds - Handle Error fields                                   *
      **********************************************************************
     C     HdlErrFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'HdlErrFlds'  SrStack(q)
 
      ** Move 'OK' flags into array (for checking)
     C                   Movea     OkFields      @EI
 
      ** Set screen error indicators according to status of 'OK' flags
     C                   Z-add     1             c                 2 0
     C                   Z-add     STARTPC       e                 2 0
      *
     C     c             Dougt     NBFIELDS
     C     @EI(c)        Ifeq      'N'
     C     @EI(c)        oreq      'W'
     C                   Movel     '1'           *IN(e)
     C                   Endif
     C                   Add       1             c
     C                   Add       1             e
     C                   Enddo
 
      ** Do while error messages found
      ** Write error messages (with or without data) to subfile
     C                   Z-add     1             c
     C     c             Dowle     ArrayMax
     C     FldNameArr(C) Andne     *BLANKS
     C                   Movel     MsgIdArr(c)   MsgID
     C                   Movel     MsgDtaArr(c)  Msgdta
     C                   Exsr      SndMsg
     C                   Add       1             c
     C                   Enddo
 
      ** Do while warning messages found
      ** Write warning messages (with or without data) to subfile
     C                   Z-add     1             c
     C     c             Dowle     ArrayMax
     C     WFldNamArr(C) Andne     *BLANKS
     C                   Movel     WMsgIdArr(C)  MsgID
     C                   Movel     WMsgDtaArr(C) Msgdta
     C                   Exsr      SndMsg
     C                   Add       1             c
     C                   Enddo
 
      ** Indicate if others screens are in error
     C                   Z-add     0             i
     C     i             Dowlt     NBSCREENS
     C                   Add       1             i
     C     ScreenErr(i)  Ifne      *BLANK
     C                   Movel     'RFD0001'     MsgID
     C                   Movel     ScreenErr(i)  Msgdta
     C                   Exsr      SndMsg
     C                   Endif
     C                   Enddo
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * DftOutFlds - Default Output fields                                 *
      **********************************************************************
     C     DftOutFlds    Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'DftOutFlds'  SrStack(q)
 
     C                   Move      PCCTID        SCCTID
      *                                                                         178751
     C     ActionCode    Ifeq      'I'                                          178751
     C                   Move      *blanks       STSEQNO                        178751
     C                   Else                                                   178751
     C                   Move      PTSEQNO       STSEQNO                        178751
     C                   Endif                                                  178751
      *                                                                         178751
      ** If action is reassign, transaction reference is shown as blank         178751
      ** as it is always defaulted                                              178751
      *                                                                         178751
     C     ActionCode    Ifeq      'R'                                          178751
     C                   Move      *blanks       STRNSID                        178751
     C                   Else                                                   178751
     C                   Move      PTRNSID       STRNSID
     C                   Endif                                                  178751
      *                                                                         178751
     C                   Move      PFilRef       SFilRef
     C                   Move      PCCtTyp       SCctTyp
     C                   Move      PCctTyc       SCctTyc                        184060
     C                   Move      PBENF1        SBENF1
     C                   Move      PBENF2        SBENF2
     C                   Move      PBENF3        SBENF3
     C                   Move      PBENF4        SBENF4
     C                   Move      PBENF5        SBENF5
     C                   Move      PACCI35       SACCI35
     C                   Move      PACCI11       SACCI11
     C                   Move      PORDI35       SOINST
     C                   Move      PORDI11       SOINS1
     C                   Move      PORDCU1       SORDCU1
     C                   Move      PORDCU2       SORDCU2
     C                   Move      PORDCU3       SORDCU3
     C                   Move      PORDCU4       SORDCU4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      SORDCU5 = PORDCU5                                          CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      PCCTAMT       SCCTAMT
     C                   Move      PCCTCCY       SCCTCCY
     C                   Move      PCRDVDT       SCRDVDT
     C                   Move      PXRATE        SXRATE
     C                   Move      PXRATEO       SXRATEO
     C                   Move      PORIGAM       SORIGAM
     C                   Move      PORIGCY       SORIGCY
     C                   Move      PPAYAMT       SPAYAMT
     C                   Move      PPAYCCY       SPAYCCY
     C                   Move      PCcyChg       SCCyChg
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
     C**********************************************************************
      /EJECT
      **********************************************************************
      * RtvFields - Retrieve Fields                                        *
      **********************************************************************
     C     RtvFields     Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'RtvFields'   SrStack(q)
 
     C                   Move      MPCCTID       SCCTID
     C                   Move      MPTRNSID      STRNSID
     C                   Move      MPFilRef      SFilRef
     C                   Move      MPCctTyp      SCctTyp
     C                   Move      MPCctTyc      SCctTyc                        184060
     C                   Move      MPBENF1       SBENF1
     C                   Move      MPBENF2       SBENF2
     C                   Move      MPBENF3       SBENF3
     C                   Move      MPBENF4       SBENF4
     C                   Move      MPBENF5       SBENF5
     C                   Move      MPACCI35      SACCI35
     C                   Move      MPACCI11      SACCI11
     C                   Move      MPORDI35      SOINST
     C                   Move      MPORDI11      SOINS1
     C                   Move      MPORDCU1      SORDCU1
     C                   Move      MPORDCU2      SORDCU2
     C                   Move      MPORDCU3      SORDCU3
     C                   Move      MPORDCU4      SORDCU4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   EVAL      SORDCU5 = MPORDCU5                                         CSW207
     C                   ENDIF                                                                CSW207
     C                   Move      MPCCTAMT      SCCTAMT
     C                   Move      MPCCTCCY      SCCTCCY
     C                   Move      MPCRDVDT      SCRDVDT
     C                   Move      MPXRATE       SXRATE
     C                   Move      MPXRATEO      SXRATEO
     C                   Move      MPORIGAM      SORIGAM
     C                   Move      MPORIGCY      SORIGCY
     C                   Move      MPPAYAMT      SPAYAMT
     C                   Move      MPPAYCCY      SPAYCCY
     C                   Move      MPCcyChg      SCCyChg
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
     C**********************************************************************
      /EJECT
      **********************************************************************
      * FmtAmt - FORMAT AMOUNT FOR DISPLAY                                 *
      **********************************************************************
     C     FmtAmt        Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'FmtAmt'      SrStack(q)
 
     C                   Callb     'ZA0920'
     C                   Parm      *BLANK        RtnCod
     C                   Parm                    AmtN13D0
     C                   Parm                    Qecn
     C                   Parm                    BndCsp
     C                   Parm      *BLANK        AmtA14
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * KeyPress - Key pressed                                             *
      **********************************************************************
     C     KeyPress      Begsr
 
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'KeyPress'    SrStack(q)
 
     C                   Movel     *BLANK        KeyPressed
 
     C                   Select
     C     *INKC         Wheneq    '1'
     C                   Movel     '03'          KeyPressed
                                                                                CFT007
      *                                                                         CFT007
      ** If F4 pressed, call BIC database + modules                             CFT007
      *                                                                         CFT007
     C                   WHEN      *Inkd = *ON                                  CFT007
     C                   EVAL      KeyPressed = '04'                            CFT007
      *                                                                         CFT007
      ** If F16 pressed, call BIC database + modules                            CFT007
      *                                                                         CFT007
     C                   WHEN      *Inkq = *ON                                  CFT007
     C                   EVAL      KeyPressed = '16'                            CFT007
 
     C     *INKE         Wheneq    '1'
     C                   Movel     '05'          KeyPressed
     C     ActionCode    Ifeq      'R'
     C                   Move      MPCCTID       SCCTID
     C                   Else
     C                   Exsr      RtvFields
     C                   Endif
 
     C     *INKJ         Wheneq    '1'
     C                   Movel     '10'          KeyPressed
 
     C     *INKK         Wheneq    '1'
     C                   Movel     '11'          KeyPressed
 
     C     *INKL         Wheneq    '1'
     C                   Movel     '12'          KeyPressed
 
     C                   Endsl
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * SndMsg  - Send a message                                           *
      **********************************************************************
     C     SndMsg        Begsr
 
     C                   IF        %subst(MSGID:1:2) = 'ME'                                   CSW215
     C                   EVAL      MsgF = 'GBMEMSG'                                           CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      MsgF = 'FTUSRMSG'                                          CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
      **  Set up subroutine stack name
     C                   Add       1             q
     C                   Movea     'SndMsg'      SrStack(q)
 
      ** Only write message if requested
     C     Msgid         Ifne      *BLANK
     C                   Callb     'AOCREPT'
     C                   Parm                    MsgID
     C                   Parm                    Msgf
     C                   Parm                    Msglib
     C                   Parm                    Msgdta
     C                   Parm      '*SAME'       Msgrel
     C                   Parm                    PSProcName
     C                   Parm      *BLANK        Msgq
     C                   Parm      *BLANK        Msgt
      *
     C                   Movel     *BLANK        MsgID
     C                   Movel     *BLANK        Msgdta
      *
     C                   Endif
      *
 
      **  Unwind subroutine stack name
     C                   Movea     *BLANKS       SrStack(q)
     C                   Sub       1             q
 
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      * *INZSR - INITIAL PROCESSING (CALLED ONCE)                          *
      **********************************************************************
     C     *INZSR        Begsr
      *
      ** Parameters
      *
     C     *ENTRY        Plist
 
      ** INPUT PARAMETERS
 
      ** Return code
     C                   Parm                    RetCodeIn
 
      ** Action Code
     C                   Parm                    ActionCode
 
      ** CCt type
     C                   Parm                    @CctTyp           2
     C                   Parm                    @FilRef          16
 
      ** Memorize fields for F5
     C                   Parm                    MemoFields        1
 
      ** Details CCT (in screen format)
     C                   Parm                    ScreenDtl
 
      ** Fields in error
     C                   Parm                    OkFields
 
      ** Other Screen in error
     C                   Parm                    ScreenErr
 
      ** Errors
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
      ** Warnings
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
 
      ** OUTPUT PARAMETERS
 
      ** Function key pressed
     C                   Parm                    KeyPressed        2
 
      ** Old Request for transfert ID (for Reassign mode)
     C                   Parm                    OldCctID
      * Cursor field for Bic Database +                                         CFT007
     C                   Parm                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
 
      ** END OF PARAMETERS DECLARATION
 
      ** Initialize program name
      *
     C                   Movel     'FTM1022DP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   Movel     PsJobName     SWSID
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         Ifeq      'M'
     C                   Seton                                        98
     C                   Endif
      *
     C                   Movel     AGMRDT        SRUNA
     C                   Movel     PSUser        SUSER
                                                                                              CSW207
      ** Check Swift 2007 is installed                                                        CSW207
                                                                                              CSW207
     C                   Call      'SWIF2007'                                                 CSW207
     C                   PARM                    RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCd  = 'CSW2007'                                         CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   EVAL      *IN84  = *ON                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   EVAL      *IN84  = *OFF                                              CSW207
     C                   ENDIF                                                                CSW207
 
      ** Message subfile control '+'
     C                   Seton                                        77
 
      ** Set screen protect/non-display indicators
     C                   Endsr
      **********************************************************************
      /EJECT
      **********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
** Ctdata CPY@
(c) Finastra International Limited 2001
