     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Determine Status of transaction for scr')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer MT101 / MT102 messages                *
      *                                                               *
      *  FTVDSPSTS - Retrieve message status for display on screen    *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 188649 *CREATE     Date 08Feb01               *
      *                 xxxxxx             Date DDmmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  188649 - Funds Transfer MT101 and MT102 Messages             *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D MessageVar      DS
     D  MsgDta                 1    132
     D  Text1                       132
     D  Text2                       512
 
 
     D  MsgId                         7
     D  MsgF                         10
 
 
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
 
     C                   Select
     C                   When      AuthFlag  <> *Blank
     C                   Eval      MsgId     = 'RFTA001'
 
     C                   When      AuthFlag  = *Blank AND
     C                             AuthUser1 <> *Blank
     C                   Eval      MsgId =   'RFTA002'
 
     C                   When      AuthFlag  = *Blank AND
     C                             AuthUser1 = *Blank AND
     C                             AuthUser2 = *Blank
     C                   Eval      MsgId =   'RFTA003'
 
     C                   EndSl
 
     C                   If        MsgID <> *Blanks
     C                   Call      'MEC1150'
     C                   Parm                    Msgid
     C                   Parm                    MsgF
     C                   Parm      *Blanks       MsgDta
     C                   Parm      *Blanks       Text1
     C                   Parm      *Blanks       Text2
 
     C                   Movel     Text1         Text
 
     C                   Endif
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   PARM                    AuthUser1        10
     C                   PARM                    AuthUser2        10
     C                   PARM                    AuthFlag          1
     C                   PARM                    Text             20
 
      ** Access Bank Details
 
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @rtcd
     C                   Parm      '*FIRST '     @optn
     C     sdbank        Parm      sdbank        dsfdy
 
 
     C                   Eval      MsgF = BJCNCD + 'FTUSRMSG'
 
 
      *  Program, module and procedure names for database error processing.*
      *  The following /COPY sets these values, and also defines LDA as    *
      *  an external data area                                             *
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      **********************************************************************
 
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
