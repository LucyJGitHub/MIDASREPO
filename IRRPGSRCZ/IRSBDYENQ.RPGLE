     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Business day convention enq single ccy')      *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSBDYENQ - Business Day Conventions Enquiry Single Ccy      *
      *                                                               *
      *  Function:  This module will allow the business day convention*
      *             screen to be called from the Deals File Enquiry   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CIR017             Date 10Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005  *CREATE    Date 21Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *                                                               *
      *****************************************************************
      /EJECT
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
 
      ** External DS for SAR Details                                                          CIR017
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR017
                                                                                              CIR017
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D PScrData      E DS                  EXTNAME(IRSBDYPD)
      ** Business Day Convention Format Definition File
 
     D PRTCD           S              7A                                                      CIR017
     D POPTN           S              7A                                                      CIR017
     D PSARD           S              6A                                                      CIR017
     D CIR017          S              1A                                                      CIR017
      ** Redefine POKFlags to cater for Their Side fields                                     CIR017
     D POkFlags        S             44                                                       CIR017
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
 
      ** If CIR017 is on, save out RetCodeIn to indicate where                                CIR017
      ** call was done from. Then clear out RetCodeIn                                         CIR017
                                                                                              CIR017
     C                   If        CIR017 = 'Y'                                               CIR017
     C                   Eval      WCallFunc = RetCodeIn                                      CIR017
     C                   Eval      RetCodeIn = *Blanks                                        CIR017
     C                   ELSE                                                                 CIR017
     C                   Eval      WCallFunc = *Blanks                                        CIR017
     C                   EndIf                                                                CIR017
      *                                                                                       CIR017
     C                   Eval      POKFlags = *All'Y'
 
     C                   DoU       PFuncKey = '03' or
     C                             PFuncKey = '12' or
     C                             PFuncKey = *Blanks
 
      ** If CIR017 is on, the code of the main calling function is                            CIR017
      ** passed to the display module through the return code parm                            CIR017
                                                                                              CIR017
      ** Display screen fields
 
     C                   CallB     'IRSBDYDSP'
     C**********         Parm      *Blanks       RetcodeIn                                    CIR017
     C                   Parm                    WCallFunc                                    CIR017
     C                   Parm      'E'           PActCode          1
     C                   Parm                    PDlnm             6
     C**********         Parm                    POkFlags         25                          CIR017
     C                   Parm                    POkFlags                                     CIR017
     C                   Parm                    MsgIdArr
     C                   Parm                    WMsgIdArr
     C                   Parm      BJMRDT        PDate             7
     C                   Parm                    PScrData
     C                   Parm      *Blanks       PFuncKey          2
     C                   Enddo
 
     C                   MoveL     '1'           *INLR
 
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
     C                   Parm                    PDlnm
     C                   Parm                    PScrData
     C                   Parm                    PFuncKey
 
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
 
      ** Check if CIR017 - Separate Business Day Convention for SIRS                          CIR017
                                                                                              CIR017
     C                   CALL      'AOSARDR0'                                                 CIR017
     C                   PARM      *BLANKS       PRTCD                                        CIR017
     C                   PARM      '*VERIFY'     POPTN                                        CIR017
     C                   PARM      'CIR017'      PSARD                                        CIR017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR017
                                                                                              CIR017
     C                   IF        PRTCD <> *BLANKS AND                                       CIR017
     C                             PRTCD <> '*NRF   '                                         CIR017
     C     *LOCK         IN        LDA                                                        CIR017
     C                   EVAL      DBASE = 2                                                  CIR017
     C                   EVAL      DBKEY = 'CIR017'                                           CIR017
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR017
     C                   OUT       LDA                                                        CIR017
     C                   EXSR      *PSSR                                                      CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C                   IF        PRTCD = *BLANKS                                            CIR017
     C                   EVAL      CIR017 = 'Y'                                               CIR017
     C                   ELSE                                                                 CIR017
     C                   EVAL      CIR017 = 'N'                                               CIR017
     C                   ENDIF                                                                CIR017
      *                                                                                       CIR017
     C     *LIKE         DEFINE    RetCodeIn     WCallFunc                                    CIR017
                                                                                              CIR017
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
