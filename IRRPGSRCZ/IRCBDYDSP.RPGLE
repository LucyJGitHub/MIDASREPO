     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Business day convention cross ccy display')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCBDYDSP - Business Day Conventions Cross Ccy Display       *
      *                                                               *
      *  Function:  This module will allow the business day convention*
      *             screen to de displayed.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CIR005  *CREATE    Date 21Jan00               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *                                                               *
      *****************************************************************
      /EJECT
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FIRCBDYDSDFCF   E             WORKSTN
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(60)
     D E               S              2  0
     D C               S              2  0
 
     D PScrData      E DS                  EXTNAME(IRCBDYPD)
      ** Business Day Convention Format Definition File
                                                                                              CIR008
      ** External DS for SAR Details                                                          CIR008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR008
                                                                                              CIR008
      ** Short DS for access programs                                                         CIR008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR008
                                                                                              CIR008
     D PRTCD           S              7A                                                      CIR008
     D POPTN           S              7A                                                      CIR008
     D PSARD           S              6A                                                      CIR008
     D CIR008          S              1A                                                      CIR008
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   MoveL     '0'           *IN09
     C                   MoveL     '1'           *IN19
     C                   MoveL     '0'           *IN08
     C                   Move      'N'           WFlag             1
     C                   MoveA     POkFlags      @EI
 
     C                   Eval       C = 1
     C                   Eval       E = 20
 
      ** Seton all indicators for invalid screen fields.
 
     C                   DoU        C > 45
 
     C                   If         @EI(C) <> 'Y'
     C                   MoveL     '1'           *IN(E)
     C                   Eval      WFlag = 'Y'
     C                   Endif
 
     C                   Add       1             C
     C                   Add       1             E
     C                   Enddo
 
     C                   If        WFlag = 'N'
     C                   MoveL     '1'           *IN08
     C                   Endif
 
     C                   Z-add     1             C
 
      ** Process all error messages
 
     C                   DoW       C <= ArrayMax and
     C                             MsgIdArr(C) <> *Blanks
     C                   MoveL     *Blanks       ZAMSID
     C                   MoveL     MsgIdArr(C)   ZAMSID
     C                   Call      'ZA0240'
     C                   Parm                    ZAMSID           10
     C                   Add       1             C
     C                   Enddo
 
     C                   Z-add     1             C
 
      ** Process all warning messages
 
     C                   DoW       C <= ArrayMax and
     C                             WMsgIdArr(C) <> *Blanks
     C                   MoveL     *Blanks       ZAMSID
     C                   MoveL     WMsgIdArr(C)  ZAMSID
     C                   Call      'ZA0240'
     C                   Parm                    ZAMSID           10
     C                   Add       1             C
     C                   Enddo
 
      ** Protect screen fields when action code is E or R.
      ** or FRA/IRS Deals Authorisation is installed and Action = 'X'                         CIR008
 
     C                   If        PActCode = 'E' or
     C                             PActCode = 'R'
     C                             OR PActCode = 'X' AND CIR008 = 'Y'                         CIR008
     C                   MoveL     '1'           *IN09
     C                   Endif
 
     C                   TIME                    STIME
     C                   Write     IRCBDCF0
     C                   Write     #MSGCTL
     C                   Read      IRCBDCF0                               70
 
     C                   Reset                   MsgIdArr
     C                   Reset                   WMsgIdArr
     C                   Eval       C = 1
     C                   Eval       E = 20
 
      ** Initialise all indicators
 
     C                   DoU        C > 45
     C                   MoveL     '0'           *IN(E)
     C                   Add       1             C
     C                   Add       1             E
     C                   Enddo
 
     C                   Select
     C                   When      *INKC = '1'
     C                   Move      *Blanks       PScrData
     C                   Eval      PFuncKey = '03'
 
     C                   When      *INKL = '1'
     C                   Eval      PFuncKey = '12'
     C                   Endsl
 
     C                   Return
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
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    PActCode          1
     C                   Parm                    SDlnm
     C                   Parm                    POkFlags         60
     C                   Parm                    MsgIdArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    PDate             7
     C                   Parm                    PScrData
     C                   Parm                    PFuncKey          2
 
     C                   MoveL     PSJobName     SWSID
     C                   MoveL     PDate         SRUNA
     C                   MoveL     PsUser        SUSER
 
     C                   MoveL     '*'           ##PGM
                                                                                              CIR008
      ** Check if FRA/IRS Deals Authorisation is installed                                    CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRTCD                                        CIR008
     C                   PARM      '*VERIFY'     POPTN                                        CIR008
     C                   PARM      'CIR008'      PSARD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRTCD <> *BLANKS AND                                       CIR008
     C                             PRTCD <> '*NRF   '                                         CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBASE = 1                                                  CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRTCD = *BLANKS                                            CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
