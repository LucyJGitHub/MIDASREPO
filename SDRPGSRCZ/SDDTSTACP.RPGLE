     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Deal Type/Sub-Type Acceptance')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDDTSTACP - SD Deal Type/Subtype Acceptance                  *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060.                         *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Background *
      *                         Job                                   *
      *             SDC000061 - SD Central Data Acceptance on         *
      *                         Effective Date                        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11785           Date 29Jul06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11785 - DB error when deleting a record                   *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRZONE    - Zonal file update routine                        *
      *  SRACCP    - Acceptance file update routine                   *
      *  SRDELAY   - Delay job routine                                *
      * *PSSR      - Error processing                                 *
      * *INZSR     - Initialise                                       *
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
 
      ** SD Deal Type/Subtype Update Logical File
     FFDDTSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** SD Deal Type/Subtype Acceptance Update Logical File
     FSDADTSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:SDADTSPD)
     F                                     COMMIT
     FFDDSX1L0  UF A E           K DISK    INFSR(*PSSR)                                     BUG11785
     F                                     COMMIT                                           BUG11785
      ** Extended Deal Sub-type  (Retrieval index Prefix VH.)                               BUG11785
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D C_AutoAccept    C                   CONST('Y')
     D C_AcceptEffDte  C                   CONST('SDC000061')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Deal Type/Sub-type Acceptance file
     D W_SDADTSPD    E DS                  EXTNAME(SDADTSPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry parameters
     D PData           S           4000A
     D PRetCode        S              7A
     D PProgram        S             10A
 
      ** Key fields
     D KDtpe11         S                   LIKE(DTPE11)
     D KDlst11         S                   LIKE(DLST11)
     D KClas11         S                   LIKE(CLAS11)                                     BUG11785
 
      ** QCMDEXC Parameters
     D QCMD            S             80A
     D QLEN            S             15  5
 
      ** Work variable
     D W_Attempt       S              3  0
     D W_EffDate       S                   LIKE(EACC11)
     D W_Narr          S                   LIKE(NARR11)
     D W_Instype       S                   LIKE(INNR)
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** Move deal type/subtype data for processing
 
     C                   EVAL      PRetcode = *Blanks
     C                   EVAL      W_Sdadtspd = PData
 
      ** Save ammendable fields
 
     C                   EVAL      W_EffDate = EACC11
     C                   EVAL      W_Narr    = NARR11
     C                   EVAL      W_InsType = INNR
 
     C                   IF        AACC11   = C_AutoAccept   OR
     C                             PProgram = C_AcceptEffDte
 
     C                   EXSR      SRZONE
     C                   ELSE
 
     C                   EXSR      SRACCP
     C                   ENDIF
                                                                                            BUG11785
     C                   EXSR      SREXTN                                                   BUG11785
                                                                                            BUG11785
 
      ** Commit changes if no error was encountered
 
     C                   IF        PRetcode = *Blanks
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
 
      ** Exit program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SRZONE - Zonal File Update Routine                            *
      *                                                               *
      *****************************************************************
 
     C     SRZONE        BEGSR
 
      ** Update deal type/subtype
 
     C                   EVAL      KDtpe11 = DTPE11
     C                   EVAL      KDlst11 = DLST11
     C                   EVAL      KClas11 = CLAS11                                         BUG11785
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Fddtstl0    CHAIN(E)  FDDTSTL0
 
      ** If record is locked to another job, wait 1 second and try again
 
     C                   IF        %ERROR
     C                   EXSR      SRDELAY
     C                   EVAL      W_Attempt = W_Attempt + 1
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        %ERROR
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'FDDTSTL0'
     C**********         EVAL      DBKEY  =  KDtpe11 + KDlst11                              BUG11785
     C                   EVAL      DBKEY  =  KDtpe11 + KDlst11 + KClas11                    BUG11785
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRZONE '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(FDDTSTL0)
 
      ** Reload input data before updating record,
      ** all fields are maintained centrally
 
     C                   EVAL      EACC11 = BJRDNB
     C                   EVAL      NARR11 = W_Narr
     C                   EVAL      INNR = W_InsType
     C                   EVAL      TYLC11 = 'A'
     C                   EVAL      LCD11 = BJRDNB
     C                   UPDATE    FDDTSTPD
 
     C                   ELSE
 
      ** Write to zonal file if not found
 
     C                   EVAL      EACC11 = BJRDNB
     C                   EVAL      TYLC11 = 'I'
     C                   EVAL      LCD11 = BJRDNB
     C                   WRITE     FDDTSTPD
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACCP - Acceptance File Update Routine                       *
      *                                                               *
      *****************************************************************
 
     C     SRACCP        BEGSR
 
      ** Check if record exists
 
     C                   EVAL      KDtpe11 = DTPE11
     C                   EVAL      KDlst11 = DLST11
     C                   EVAL      KClas11 = CLAS11                                         BUG11785
     C                   EVAL      W_Attempt = 0
 
     C                   DOW       W_Attempt < 100
     C     K@Sdadtsl0    CHAIN(E)  SDADTSL0
 
      ** If record is locked to another job, wait 1 second and try again
 
     C                   IF        %ERROR
     C                   EXSR      SRDELAY
     C                   EVAL      W_Attempt = W_Attempt + 1
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        %ERROR
 
      ** Database update error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDADTSL0'
     C**********         EVAL      DBKEY  =  KDtpe11 + KDlst11                              BUG11785
     C                   EVAL      DBKEY  =  KDtpe11 + KDlst11 + KClas11                    BUG11785
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRACCP '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        %FOUND(SDADTSL0)
 
      ** Reload input data before updating record
 
     C                   EVAL      W_Sdadtspd = PData
     C                   UPDATE    SDADTSPD
     C                   ELSE
 
      ** Write to acceptance file if not found
 
     C                   WRITE     SDADTSPD
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                     BUG11785
      /EJECT                                                                                BUG11785
      *****************************************************************                     BUG11785
      *                                                               *                     BUG11785
      * SREXTN - Extension File Update Routine                        *                     BUG11785
      *                                                               *                     BUG11785
      *****************************************************************                     BUG11785
                                                                                            BUG11785
     C     SREXTN        BEGSR                                                              BUG11785
                                                                                            BUG11785
      ** Check if record exists                                                             BUG11785
                                                                                            BUG11785
     C                   EVAL      KDtpe11 = DTPE11                                         BUG11785
     C                   EVAL      KDlst11 = DLST11                                         BUG11785
     C                   EVAL      KClas11 = CLAS11                                         BUG11785
     C                   EVAL      W_Attempt = 0                                            BUG11785
                                                                                            BUG11785
     C                   DOW       W_Attempt < 100                                          BUG11785
     C     K@Fddsx1l0    CHAIN(E)  FDDSX1L0                                                 BUG11785
                                                                                            BUG11785
      ** If record is locked to another job, wait 1 second and try again                    BUG11785
                                                                                            BUG11785
     C                   IF        %ERROR                                                   BUG11785
     C                   EXSR      SRDELAY                                                  BUG11785
     C                   EVAL      W_Attempt = W_Attempt + 1                                BUG11785
     C                   ELSE                                                               BUG11785
     C                   LEAVE                                                              BUG11785
     C                   ENDIF                                                              BUG11785
                                                                                            BUG11785
     C                   ENDDO                                                              BUG11785
                                                                                            BUG11785
     C                   IF        %ERROR                                                   BUG11785
                                                                                            BUG11785
      ** Database update error                                                              BUG11785
                                                                                            BUG11785
     C     *LOCK         IN        LDA                                                      BUG11785
     C                   EVAL      DBFILE =  'FDDSX1L0'                                     BUG11785
     C                   EVAL      DBKEY  =  KDtpe11 + KDlst11 + KClas11                    BUG11785
     C                   EVAL      DBPGM  =  PSProcPgm                                      BUG11785
     C                   EVAL      DBASE  =  004                                            BUG11785
     C                   EVAL      DBMOD  =  PSProcMod                                      BUG11785
     C                   EVAL      DBPROC =  'SR/SREXTN '                                   BUG11785
     C                   OUT       LDA                                                      BUG11785
     C                   EXSR      *PSSR                                                    BUG11785
     C                   ENDIF                                                              BUG11785
                                                                                            BUG11785
     C                   IF        %FOUND(FDDSX1L0)                                         BUG11785
                                                                                            BUG11785
     C                   EVAL      XXMOBC = 0                                               BUG11785
     C                   EVAL      XXPMOB = 0                                               BUG11785
     C                   EVAL      XXDIST = 0                                               BUG11785
     C                   EVAL      XXDEPT = 0                                               BUG11785
     C                   EVAL      XXFRNI = 'N'                                             BUG11785
                                                                                            BUG11785
     C                   UPDATE    FDDTSTF6                                                 BUG11785
                                                                                            BUG11785
     C                   ELSE                                                               BUG11785
                                                                                            BUG11785
     C                   EVAL      XXXXXX = DTPE11                                          BUG11785
     C                   EVAL      XXDSTC = DLST11                                          BUG11785
     C                   EVAL      XXCLAS = CLAS11                                          BUG11785
     C                   EVAL      XXMOBC = 0                                               BUG11785
     C                   EVAL      XXPMOB = 0                                               BUG11785
     C                   EVAL      XXDIST = 0                                               BUG11785
     C                   EVAL      XXDEPT = 0                                               BUG11785
     C                   EVAL      XXFRNI = 'N'                                             BUG11785
                                                                                            BUG11785
     C                   WRITE     FDDTSTF6                                                 BUG11785
                                                                                            BUG11785
     C                   ENDIF                                                              BUG11785
                                                                                            BUG11785
     C                   ENDSR                                                              BUG11785
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELAY - Delay Job Routine                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDELAY       BEGSR
 
      ** Execute Delay Job command
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    QCMD
     C                   PARM                    QLEN
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PData
     C                   PARM                    PRetcode
     C                   PARM                    PProgram
 
      ** Initialize command exec parameters
 
     C                   EVAL      QCMD = 'DLYJOB DLY(1)'
     C                   EVAL      QLEN = 80
 
      ** Deal type/subtype code keylist
 
     C     K@FDDTSTL0    KLIST
     C                   KFLD                    KDTPE11
     C                   KFLD                    KDLST11
     C                   KFLD                    KCLAS11                                    BUG11785
 
      ** Deal type/subtype code acceptance keylist
 
     C     K@SDADTSL0    KLIST
     C                   KFLD                    KDTPE11
     C                   KFLD                    KDLST11
     C                   KFLD                    KCLAS11                                    BUG11785
 
      ** Extended Deal subtype code keylist                                                 BUG11785
                                                                                            BUG11785
     C     K@FDDSX1L0    KLIST                                                              BUG11785
     C                   KFLD                    KDTPE11                                    BUG11785
     C                   KFLD                    KDLST11                                    BUG11785
     C                   KFLD                    KCLAS11                                    BUG11785
                                                                                            BUG11785
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Datebase error
 
     C     @RTCD         IFNE      *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR '
     C                   EXSR      *PSSR
     C                   OUT       LDA
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
      ** Update return code and rollback file updates
 
     C                   EVAL      PRetcode = '*ERROR '
     C                   ROLBK
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
