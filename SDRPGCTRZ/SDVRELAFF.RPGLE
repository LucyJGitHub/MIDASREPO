     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Religious Affiliation Codes')        *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVRELAFF - Validate Religious Affiliation Codes             *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *    This source is created as a validation for the third       *
      *    tax details.                                               *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG25854           Date 08Sep09               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25854 - ACUD difficulties with State Code and Religion    *
      *  CER054 - German Features - Church Tax                        *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LO              C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Religious Affiliation Details
     D SDRLAF        E DS                  EXTNAME(SDRLAFPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D DDSTCD          S              2A                                                    BUG25854
     D DDRLAF          S              4A
     D WRLAF           S              4A
     D OKRLAF          S              1A
     D @RUN            S              1A
 
      ** Parameter for Access Object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
 
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
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Validate Religious Affiliation Code
 
     C                   EVAL      WRLAF = %XLATE(LO:UP:DDRLAF)
 
     C                   EXSR      SRValRelAff
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        OKRLAF = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRelAff - Validate Religious Affiliation Code             *
      *                                                               *
      *****************************************************************
 
     C     SRValRelAff   BEGSR
 
     C                   IF        DDRLAF <> *BLANKS AND
     C                             DDRLAF <> 'NONE'
      *
      ** Check if the Religious Affiliation Code is a valid code on the
      ** religious affiliation code table.
      *
     C                   MOVEL     DDRLAF        PKEY1
 
     C                   CALL      'AORLAFR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C     SDRLAF        PARM      SDRLAF        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      OKRLAF = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLAF'      FldNamXAr(Idx)
     C                   MOVEL     'USR8323'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      DDRLAF = AFRLAF
      *                                                                                     BUG25854
      ** State Code is mandatory when Religious Affiliation Code is a valid code            BUG25854
      *                                                                                     BUG25854
     C                   IF        DDSTCD = *BLANKS                                         BUG25854
     C                   ADD       1             Idx                                        BUG25854
     C                   MOVEL     'DDRLAF'      FldNamXAr(Idx)                             BUG25854
     C                   MOVEL     'USR8439'     MsgIDXAr(Idx)                              BUG25854
     C                   ENDIF                                                              BUG25854
      *                                                                                     BUG25854
     C                   ENDIF
 
      * Otherwise
     C                   ELSE
     C                   EVAL      DDRLAF = 'NONE'
 
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
 
     C                   ENDSR
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
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Religious Affiliation Code
     C                   PARM                    DDRLAF
     C                   PARM                    DDSTCD                                     BUG25854
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Religious Affiliation Code - OK
     C                   PARM                    OKRLAF
 
 
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
 
     C                   IF        @RUN = *Blanks
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2009
