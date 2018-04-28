     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT RFT credit display 1')                        *
      **********************************************************************
      *                                                                    *
      *  Midas - Funds Transfer Module                                     *
      *                                                                    *
      *  FTM1012DP -  Display one RFT detail : screen 1                    *
      *                                                                    *
      *  Function:  This module display a detail of a Request For          *
      *  Transfert                                                         *
      *                                                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                                    *
      *  Last Amend No. MD022652           Date 07Oct13                    *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188649             Date 09Feb01                    *
      * Midas DBA 3.03 ----------------------------------------------------*
      *                 178751             Date 09May00                    *
      *                 CFT007             Date 21Mar00                    *
      *                 CFT006  *CREATE    Date 22Sep99                    *
      *  Prev Amend No.                    Date ddmmmyy                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD022652 - Excluded Phase Processing                              *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  188649 - Include authorisation text                               *
      *  178751 - Auto generation of references                            *
      *  CFT007 - BIC database Plus                                        *
      *  CFT006 - Swift messages MT101/MT102                               *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTM1012DDFCF   E             WORKSTN
      **********************************************************************
      *                                                                    *
      * ID F  C  H  L    FUNCTION OF INDICATORS                            *
      *                                                                    *
      *     29-55 Field Error - highlight screen fields                    *
      *     70    Protect TRNSID                                           *
      *     71    Protect fields screen (Except RFT ID, TRNSID)            *
      *     74    Protect RFT ID                                           *
      *     72    Disable F5                                               *
      *     73    Disable F10                                              *
      *     76    Hide BIC search key                                      *
      *     78    To display appropriate title (incoming or outgoing)      *
      *     82    Bic Database + installed enable F4, F16                  *    CFT007
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
     D NBSCREENS       C                   Const(3)
 
      ** Fields on the screen
     D NBFIELDS        C                   Const(27)
 
      ** Place of the first indicator PC on the screen
     D STARTPC         C                   Const(29)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
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
     D ScreenDtl     E DS                  EXTNAME(FT101DSPD)
 
      * Fields of the screen memorized
     D ScreenMem     E DS                  EXTNAME(FT101DSPD) PREFIX(M)
 
      ** Error Indicators
     D OkFields      E DS                  EXTNAME(FTE101S1PD)
 
     D Scsard        E DS                  EXTNAME(SCSARDPD)                    CFT007
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS                                   CFT007
                                                                                CFT007
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
 
      ** Old RFT id
     D OldRftID        S                   Like(PRFTHDR)
 
      ** Old Transaction reference
     D OldTransID      S                   Like(PTRNSID)
 
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
      *                                                                         CFT007
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
                                                                                CFT007
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
     C                   If        RftTyp = 'RO'
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
     C                   Movel     '1'           *IN74
     C                   Movel     '1'           *IN70
 
     C     ActionCode    Wheneq    'R'
      *                                                                         178751
      ***All*fields*are*protected,*except*RFT*for*transfert*ID*and****          178751
      ***Transaction*Reference****************************************          178751
      ** All fields are protected, except RFT for transfer ID                   178751
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
     C                   Movel     '1'           *IN76                          CFT007
     C                   Movel     '0'           *IN82                          CFT007
 
     C     ActionCode    Wheneq    'X'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
     C                   Movel     '1'           *IN76                          CFT007
     C                   Movel     '0'           *IN82                          CFT007
 
     C     ActionCode    Wheneq    'D'
      ** F5 Disabled
     C                   Movel     '1'           *IN72
     C                   Movel     '1'           *IN76                          CFT007
     C                   Movel     '0'           *IN82                          CFT007
 
     C     ActionCode    Wheneq    'A'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
     C                   IF        CFT007 = 'Y'                                 CFT007
     C                   Movel     '0'           *IN76                          CFT007
     C                   Movel     '1'           *IN82                          CFT007
     C                   ELSE                                                   CFT007
     C                   Movel     '1'           *IN76                          CFT007
     C                   Movel     '0'           *IN82                          CFT007
     C                   ENDIF                                                  CFT007
 
     C     ActionCode    Wheneq    'I'
      ** F10 Disabled
     C                   Movel     '1'           *IN73
     C                   IF        CFT007 = 'Y'                                 CFT007
     C                   Movel     '0'           *IN76                          CFT007
     C                   Movel     '1'           *IN82                          CFT007
     C                   ELSE                                                   CFT007
     C                   Movel     '1'           *IN76                          CFT007
     C                   Movel     '0'           *IN82                          CFT007
     C                   ENDIF                                                  CFT007
 
     C                   Endsl
 
      ** Miscellaneous initialization depending of value of action code
      ** --------------------------------------------------------------
     C                   Select
     C     ActionCode    Wheneq    'R'
      ** We need to memorise the initial value of the key in order to
      ** know which transaction detail needs to be deleted in the former
      ** RFT
     C     KeyStored     Ifne      'Y'
     C                   Movel     'Y'           KeyStored
     C                   Movel     PRFTHDR       OldRftID
     C                   Movel     PTRNSID       OldTransID
     C                   Endif
     C                   Other
     C                   Movel     'N'           KeyStored
     C                   Movel     *BLANK        OldRftID
     C                   Movel     *BLANK        OldTransID
     C                   Endsl
 
      **  Memorize fields in case of refresh (F5)
     C     MemoFields    Ifeq      'Y'
     C                   Movel     'N'           MemoFields
 
     C     ActionCode    Ifeq      'R'
     C                   Move      PRFTHDR       MPRFTHDR
     C                   Move      PTRNSID       MPTRNSID
     C                   Else
     C                   Move      PTRNSID       MPTRNSID
     C                   Move      PBNB35        MPBNB35
     C                   Move      PBNC35        MPBNC35
     C                   Move      PBNA35        MPBNA35
     C                   Move      PBND35        MPBND35
     C                   Move      PBNE35        MPBNE35
     C                   Move      PACA11        MPACA11
     C                   Move      PACA35        MPACA35
     C                   Move      PACB35        MPACB35
     C                   Move      PACC35        MPACC35
     C                   Move      PACD35        MPACD35
     C                   Move      PACE35        MPACE35
     C                   Move      PINSTA        MPINSTA
     C                   Move      PINST1        MPINST1
     C                   Move      PINST2        MPINST2
     C                   Move      PINST3        MPINST3
     C                   Move      PINST4        MPINST4
     C                   Move      PINST5        MPINST5
     C                   Move      PINPTY        MPINPTY
     C                   Move      POCUS1        MPOCUS1
     C                   Move      POCUS2        MPOCUS2
     C                   Move      POCUS3        MPOCUS3
     C                   Move      POCUS4        MPOCUS4
     C                   Move      POCUS5        MPOCUS5
     C                   Move      PASI35        MPASI35
     C                   Move      PACC11        MPACC11
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
     C                   Write     FTM1012DF1
 
     C                   Read      FTM1012DF1                             99    *
 
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
 
     C                   Move      SRFTHDR       PRFTHDR
     C                   Move      STSEQNO       PTSEQNO                        178751
     C                   Move      SCUSTRF       PCUSREF
     C                   Move      STRNSID       PTRNSID
     C                   Move      SSNDREF       PSNDREF
     C                   Move      SBNB35        PBNB35
     C                   Move      SBNC35        PBNC35
     C                   Move      SBNA35        PBNA35
     C                   Move      SBND35        PBND35
     C                   Move      SBNE35        PBNE35
     C                   Move      SACA11        PACA11
     C                   Move      SACA35        PACA35
     C                   Move      SACB35        PACB35
     C                   Move      SACC35        PACC35
     C                   Move      SACD35        PACD35
     C                   Move      SACE35        PACE35
     C                   Move      SINSTA        PINSTA
     C                   Move      SINST1        PINST1
     C                   Move      SINST2        PINST2
     C                   Move      SINST3        PINST3
     C                   Move      SINST4        PINST4
     C                   Move      SINST5        PINST5
     C                   Move      SINPTY        PINPTY
     C                   Move      SOCUS1        POCUS1
     C                   Move      SOCUS2        POCUS2
     C                   Move      SOCUS3        POCUS3
     C                   Move      SOCUS4        POCUS4
     C                   Move      SOCUS5        POCUS5
     C                   Move      SASI35        PASI35
     C                   Move      SACC11        PACC11
 
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
 
     C                   Move      PRFTHDR       SRFTHDR
      *                                                                         178751
     C     ActionCode    Ifeq      'I'                                          178751
     C                   Move      *blanks       STSEQNO                        178751
     C                   Else                                                   178751
     C                   Move      PTSEQNO       STSEQNO                        178751
     C                   Endif                                                  178751
      *                                                                         178751
     C                   Move      PCUSREF       SCUSTRF
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
     C                   Move      PSNDREF       SSNDREF
     C                   Move      PBNB35        SBNB35
     C                   Move      PBNC35        SBNC35
     C                   Move      PBNA35        SBNA35
     C                   Move      PBND35        SBND35
     C                   Move      PBNE35        SBNE35
     C                   Move      PACA11        SACA11
     C                   Move      PACA35        SACA35
     C                   Move      PACB35        SACB35
     C                   Move      PACC35        SACC35
     C                   Move      PACD35        SACD35
     C                   Move      PACE35        SACE35
     C                   Move      PINSTA        SINSTA
     C                   Move      PINST1        SINST1
     C                   Move      PINST2        SINST2
     C                   Move      PINST3        SINST3
     C                   Move      PINST4        SINST4
     C                   Move      PINST5        SINST5
     C                   Move      PINPTY        SINPTY
     C                   Move      POCUS1        SOCUS1
     C                   Move      POCUS2        SOCUS2
     C                   Move      POCUS3        SOCUS3
     C                   Move      POCUS4        SOCUS4
     C                   Move      POCUS5        SOCUS5
     C                   Move      PASI35        SASI35
     C                   Move      PACC11        SACC11
 
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
 
     C                   Move      MPTRNSID      STRNSID
     C                   Move      MPBNB35       SBNB35
     C                   Move      MPBNC35       SBNC35
     C                   Move      MPBNA35       SBNA35
     C                   Move      MPBND35       SBND35
     C                   Move      MPBNE35       SBNE35
     C                   Move      MPACA11       SACA11
     C                   Move      MPACA35       SACA35
     C                   Move      MPACB35       SACB35
     C                   Move      MPACC35       SACC35
     C                   Move      MPACD35       SACD35
     C                   Move      MPACE35       SACE35
     C                   Move      MPINSTA       SINSTA
     C                   Move      MPINST1       SINST1
     C                   Move      MPINST2       SINST2
     C                   Move      MPINST3       SINST3
     C                   Move      MPINST4       SINST4
     C                   Move      MPINST5       SINST5
     C                   Move      MPINPTY       SINPTY
     C                   Move      MPOCUS1       SOCUS1
     C                   Move      MPOCUS2       SOCUS2
     C                   Move      MPOCUS3       SOCUS3
     C                   Move      MPOCUS4       SOCUS4
     C                   Move      MPOCUS5       SOCUS5
     C                   Move      MPASI35       SASI35
     C                   Move      MPACC11       SACC11
 
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
     C     *INKD         Wheneq    '1'                                          CFT007
     C                   Movel     '04'          KeyPressed                     CFT007
     C                   Exsr      MovPart                                      CFT007
                                                                                CFT007
     C     *INKQ         Wheneq    '1'                                          CFT007
     C                   Movel     '16'          KeyPressed                     CFT007
     C                   Exsr      MovPart                                      CFT007
 
     C     *INKE         Wheneq    '1'
     C                   Movel     '05'          KeyPressed
     C     ActionCode    Ifeq      'R'
     C                   Move      MPRFTHDR      SRFTHDR
     C                   Move      MPTRNSID      STRNSID
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
      **********************************************************************    CFT007
      /EJECT                                                                    CFT007
      **********************************************************************    CFT007
      * MovPart : Move part data for return to BIC database +                   CFT007
      *                                                                         CFT007
      * Called by Main                                                          CFT007
      *                                                                         CFT007
      **********************************************************************    CFT007
     C     MovPart       Begsr                                                  CFT007
                                                                                CFT007
                                                                                CFT007
                                                                                CFT007
                                                                                CFT007
                                                                                CFT007
     C                   Endsr                                                  CFT007
      **********************************************************************
      /EJECT
      **********************************************************************
      * SndMsg  - Send a message                                           *
      **********************************************************************
     C     SndMsg        Begsr
 
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
 
      ** Rft type
     C                   Parm                    RftTyp            2
 
      ** Memorize fields for F5
     C                   Parm                    MemoFields        1
 
      ** Details RFT (in screen format)
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
     C                   Parm                    OldRftID
 
      ** Old Transaction reference (for Reassign mode)
     C                   Parm                    OldTransID
                                                                                CFT007
      * Cursor field                                                            CFT007
     C                   Parm                    CsrFld                         CFT007
      * Status description                                                      188649
     C                   PARM                    SAIND                          188649
 
      ** END OF PARAMETERS DECLARATION
 
 
 
      ** Initialize program name
      *
     C                   Movel     'FTM1012DP'   DBPGM
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
(c) Misys International Banking Systems Ltd. 2001
