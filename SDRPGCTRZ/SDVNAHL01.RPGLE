     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Non-Account Holder Reference')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVNAHL01 - Validate Non-A/C Holder Reference                *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132             Date 01May13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24038           Date 20May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 01Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24038 - Add Validation that full 10 digits be populated   *
      *             in Non Account Holder Maintenance                 *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation on Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SDNon-a/c Holders - Rtv Idx
     FSDNAHOL1  IF   E           K Disk    Infsr(*PSSR)
 
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
 
     D OkNaho          S              1
     D DDNAHO          S             10
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
      ** Initialisation
 
     C                   Move      *BLANK        RetCodeIn
 
     C                   Move      *BLANK        FldNamXAr
     C                   Move      *BLANK        MsgIDXAr
     C                   Move      *BLANK        MsgDtaXAr
     C                   Z-Add     0             Idx
 
      ** Validation
 
     C                   EXSR      SRVNAHO
 
      ** If an error was found, set the return code appropriately
 
     C     OkNaho        Ifeq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Endif
 
      ** Return
 
     C                   Return
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  Validation                                                   *
      *****************************************************************
     C     SRVNAHO       BEGSR
 
     C                   IF        DDNAHO = *BLANKS OR
     C                             DDNAHO = *ZEROS
     C                   MoveL     'N'           OkNaho
     C                   Add       1             Idx
     C                   MoveL     'DDNAHO'      FldNamXAr(Idx)
als  C                   MoveL     'USR0220'     MsgIdXAr(Idx)
     C                   LEAVESR                                                            BUG24038
     C                   Endif
      *                                                                                     BUG24038
      ** Check if Reference is 10 characters long                                           BUG24038
      *                                                                                     BUG24038
     C     ' '           SCAN      DDNAHO                                                   BUG24038
     C                   IF        %FOUND                                                   BUG24038
     C                   MoveL     'N'           OkNaho                                     BUG24038
     C                   Add       1             Idx                                        BUG24038
     C                   MoveL     'DDNAHO'      FldNamXAr(Idx)                             BUG24038
     C                   MoveL     'USR9932'     MsgIdXAr(Idx)                              BUG24038
     C                   LEAVESR                                                            BUG24038
     C                   Endif                                                              BUG24038
 
      ** Access Non-A/C Holder from the Non-A/C Holders file
 
     C     DDNAHO        Chain     SDNAHOL1                           44
 
      ** Error if present already
 
     C                   IF        *IN44 = *OFF
     C                   MoveL     'N'           OkNaho
     C                   Add       1             Idx
     C                   MoveL     'DDNAHO'      FldNamXAr(Idx)
als  C                   MoveL     'USR4759'     MsgIdXAr(Idx)
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        Begsr
 
     C     *Entry        Plist
 
      ** Inputs
      ** Return Code
      ** Mailing Name and Address 1
      ** Mailing Name and Address 2
      ** Error Field Name
     C                   Parm                    RetCodeIn
     C                   Parm                    DDNAHO
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Mailing Name and Address 1-2 OK
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    Idx
     C                   Parm                    OkNaho
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
