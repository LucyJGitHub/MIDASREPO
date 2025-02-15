     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate City for Non-A/c Holders')
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVCITY01 - Validate City                                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
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
      *  Prev Amend No. 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** � D-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D DDCITY          S             35
     D DDCNA4          S             35
     D DDOKCITY        S              1
     D PTaxStat        S              1                                                       232543
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** �                                                                �
      ** � Initial processing is performed automatically: the *INZSR is   �
      ** � executed at program activation.                                �
      ** �                                                                �
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *BLANK
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      Idx = 0
 
      ** Validation
 
     C                   EXSR      SRVCITY
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKCITY = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCITY - Validate City                                       *
      *                                                               *
      *****************************************************************
 
     C     SRVCity       BEGSR
 
     C                   EVAL      DDOKCITY = 'Y'
 
      ** Default City from mailing address line 4
 
     C                   IF        DDCITY = *Blanks
     C                   EVAL      DDCITY = DDCNA4
     C                   ENDIF
 
      ***City*is*Mandatory                                                                    232543
      ** City is Mandatory if Status is 'D'isclosed                                           232543
 
     C                   IF        DDCITY = *Blanks
     C                             And PTaxStat = 'D'                                         232543
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCITY'
     C                   EVAL      MsgIDXAr(Idx)  = 'USR4794'
     C                   EVAL      DDOKCITY = 'N'
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C                   PARM                    DDCNA4
 
      ** City
 
     C                   PARM                    DDCITY
 
      ** Tax Status                                                                           232543
     C                   PARM                    PTaxStat                                     232543
                                                                                              232543
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDOKCITY
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
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
(c) Finastra International Limited 2004
