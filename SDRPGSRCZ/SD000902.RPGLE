     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Meridian Interface to PopulateWL Interfce')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000902 - Meridian Interface Program to Populate Watch      *
      *             List Interface File                               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD083  *CREATE    Date 27May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
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
 
      ** Compliance Watch Hit List File
     FSDCWDFL1  UF A E           K DISK             INFSR(*PSSR)
 
      ** Compliance Watch Hit List File
     FSDCWHTL3  UF A E           K DISK             INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Check Transaction Data File
     D PInpCwlInDS   E DS                  EXTNAME(SDCWDFPD)
 
      ** Check Transaction Data File
     D PUpdCwlInDS   E DS                  EXTNAME(SDCWDFPD)
     D                                     PREFIX(U)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
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
 
     C     KWTCHL        CHAIN     SDCWDFL1
     C                   IF        NOT %FOUND(SDCWDFL1)
     C                   WRITE     SDCWDFD0
 
     C                   ELSE
 
     C                   MOVE      UWIPROC       WIPROC
     C                   MOVE      UWISYSM       WISYSM
     C                   MOVE      UWICNUM       WICNUM
     C                   MOVE      UWICTYP       WICTYP
     C                   MOVE      UWICUST       WICUST
     C                   MOVE      UWIDDAT       WIDDAT
     C                   MOVE      UWIVDAT       WIVDAT
     C                   MOVE      UWIMDAT       WIMDAT
     C                   MOVE      UWIDEN1       WIDEN1
     C                   MOVE      UWIDEN2       WIDEN2
     C                   MOVE      UWIAMT1       WIAMT1
     C                   MOVE      UWIAMT2       WIAMT2
     C                   MOVE      UWIARLS       WIARLS
     C                   MOVE      UWISSTR       WISSTR
     C                   UPDATE    SDCWDFD0
 
     C                   ENDIF
 
     C     KWTCHL        CHAIN     SDCWHTL3
     C                   IF        NOT %FOUND(SDCWHTL3)
     C                   EVAL      W3FUNT = WIFUNT
     C                   EVAL      W3IDEN = WIIDEN
     C                   EVAL      W3BRCH = WIBRCH
     C                   EVAL      W3HSTS = *BLANKS
     C                   EVAL      W3UNCF = 'Y'
     C                   EVAL      W3TREL = *BLANKS
     C                   EVAL      W3LWCD = BJRDNB
 
     C                   WRITE     SDCWHTD0
 
     C                   ELSE
 
     C                   IF        W3HSTS = *BLANKS
     C                   EVAL      W3UNCF = 'Y'
     C                   EVAL      W3TREL = *BLANKS
     C                   UPDATE    SDCWHTD0
 
     C                   ELSE
 
     C                   DELETE    SDCWHTD0
     C                   EVAL      W3FUNT = WIFUNT
     C                   EVAL      W3IDEN = WIIDEN
     C                   EVAL      W3BRCH = WIBRCH
     C                   EVAL      W3HSTS = *BLANKS
     C                   EVAL      W3UNCF = 'Y'
     C                   EVAL      W3TREL = *BLANKS
     C                   EVAL      W3LWCD = BJRDNB
     C                   WRITE     SDCWHTD0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    pReturnCode       7
     C                   PARM                    PInpCwlInDS
 
     C     KWTCHL        KLIST
     C                   KFLD                    WIFUNT
     C                   KFLD                    WIIDEN
     C                   KFLD                    WIBRCH
 
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'SD000902'
     C                   ENDIF
 
     C                   MOVE      PInpCwlInDS   PUpdCwlInDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      pReturnCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
