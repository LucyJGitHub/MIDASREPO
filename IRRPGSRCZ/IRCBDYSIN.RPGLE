     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Business day convention cross ccy input')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCBDYSIN - Business Day Conventions Cross Ccy Input         *
      *                                                               *
      *  Function:  This module will allow the business day convention*
      *             fields to be entered for Cross Currency Swaps.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CIR005  *CREATE    Date 21Jan00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *                                                               *
      *****************************************************************
      /EJECT
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D PScrData      E DS                  EXTNAME(IRCBDYPD)
      ** Business Day Convention Format Definition File
     D  RCcy1                 35     64
     D  RCcy2                 99    128
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WrnFlag         S              1    INZ('N')
     D WSavRC1         S             30
     D WSavRC2         S             30
 
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
 
     C                   Eval      POkFlags = *All'Y'
     C                   MoveL     *Blanks       MsgIdArr
     C                   MoveL     *Blanks       WMsgIdArr
     C                   MoveL     *Blanks       WSavRC1
     C                   MoveL     *Blanks       WSavRC2
     C                   If        PActCode = 'I'
     C                   Clear                   PScrData
     C                   Endif
 
      ** Do until F3 or F12 is pressed or all screen fields are valid.
 
     C                   DoU       MsgIdArr(1) = *Blanks  and
     C                             WrnFlag = 'N'  or
     C                             PFuncKey = '03'  or
     C                             PFuncKey = '12'
 
     C                   Eval      WrnFlag = 'N'
 
      ** Display screen fields
 
     C                   CallB     'IRCBDYDSP'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    PActCode
     C                   Parm                    PDlnm             6
     C                   Parm                    POkFlags         60
     C                   Parm                    MsgIdArr
     C                   Parm                    WMsgIdArr
     C                   Parm      BJMRDT        PDate             7
     C                   Parm                    PScrData
     C                   Parm      *Blanks       PFuncKey
 
     C                   If        PFuncKey <> '03' and
     C                             PFuncKey <> '12' and
     C                             PActCode = 'I'  or
     C                             PFuncKey <> '03' and
     C                             PFuncKey <> '12' and
     C                             PActCode = 'A'
 
      ** Validate all screen fields when action code is I or A.
 
     C                   CallB     'IRCBDYVAL'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    PActCode
     C                   Parm                    PLCcy             3
     C                   Parm                    POkFlags
     C                   Parm      *Blanks       MsgIdArr
     C                   Parm                    FldNameArr
     C                   Parm      *Blanks       WMsgIdArr
     C                   Parm                    WFldNamArr
     C                   Parm                    PScrData
 
     C                   If        WMsgIdArr(1) <> *Blanks and
     C                             WSavRC1 <> RCcy1  or
     C                             WMsgIdArr(1) <> *Blanks and
     C                             WSavRC2 <> RCcy2
     C                   Eval      WrnFlag = 'Y'
     C                   Endif
     C                   Eval      WSavRC1 = RCcy1
     C                   Eval      WSavRC2 = RCcy2
     C                   Endif
 
     C                   Enddo
 
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
     C                   Parm                    PDlnm             6
     C                   Parm                    PScrData
     C                   Parm                    PFuncKey          2
 
      ** Access Bank Details
 
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*FIRST '     POPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database Error
 
     C                   If        PRtcd <> *Blanks
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBase = 1
     C                   Eval      DBKey = '*FIRST'
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Eval      PLCcy = BJLCCY
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
(c) Finastra International Limited 2001
