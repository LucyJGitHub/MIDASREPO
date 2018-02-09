     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Outgoing Payment Ext. Sett. Instn. Rpt.')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001247 - Midas SD Outgoing Payments - Extended Settlement  *
      *             Instructions Report                               *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR988376           Date 11Feb13               *
      *                 CFT045  *CREATE    Date 04Aug11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR988376 - Component SDC0602 ended in error (Child:AR988377) *
      *  CFT045 - Outgoing Payments - Extended Settlement Instructions*
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SD OPES File by Ext. Sett. Instn. No.
      *
     FSDOPESL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Standing Data Controls File Retrieval Index
      *
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SD Out. Payment Ext. Sett. Instn. Rpt. List
      *
     FSD001247P1O    E             PRINTER INFDS(SPOOL1) USROPN INFSR(*PSSR)
      *
      ** Midas SD Out. Payment Ext. Sett. Instn. Rpt. Audit
      *
     FSD001247AUO    E             PRINTER INFDS(SPOOLU) USROPN INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DS for access objects - short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File Information Data Structure for SD001247P1
      *
     D SPOOL1          DS
     D   SFile1               83     92
     D   SFNum1              123    124B 0
     D   OflLn1              188    189B 0
     D   PrtLn1              367    368B 0
      *
      ** File Information Data Structure for SD001247AU
      *
     D SPOOLU          DS
     D   SFileU               83     92
     D   SFNumU              123    124B 0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter list fields
      *
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
      *
      ** Parameters for ZSFILE
      *
     D PSeq            S              5
     D PSFile          S             10
     D PZSNum          S              6  0
     D PZSErr          S              1
      *
      ** Parameters for access object programs
      *
     D PRtcd           S              7
     D POptn           S              7
      *
      ** Other fields used
      *
     D WRun            S              1
     D WFirst          S              1
     D WFName          S             10
     D WNoRec          S              5  0
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRInit
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRProces
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SRAudit
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Subroutine to initialise variables, indicators etc.  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SRinit        BEGSR
      *
      ** Initialise report work variables
      *
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WNoRec = 0
      *
      ** Initialise mode indicator
      *
     C                   IF        PMode = 'A'
     C                   EVAL      *IN10 = *ON
     C**********         ELSEIF    PMode = 'L'                                              AR988376
     C                   ELSEIF    PMode = 'R'                                              AR988376
     C                   EVAL      *IN10 = *OFF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProces - Subroutine to process reporting of file            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SRReadf, SRAudit, SRPrint, SREnd                       *
      *                                                               *
      *****************************************************************
     C     SRProces      BEGSR
      *
      *
      ** First Read
      *
     C     *LOVAL        SETLL     SDOPESL0
      *
     C                   EXSR      SRReadf
      *
      ** Print Audit Report if file is empty
      *
     C                   IF        %EOF(SDOPESL0)
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDOPESL0)
      *
      ** Process Report Lines
      *
     C                   EXSR      SRPrint
      *
      ** Read next record
      *
     C                   EXSR      SRReadf
      *
     C                   ENDDO
      *
     C                   EXSR      SREnd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReadf - Subroutine to read file                             *
      *                                                               *
      * Called by: SRProces                                           *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SRReadf       BEGSR
      *
     C                   DOU       (%EOF(SDOPESL0)) OR
     C                             (PMode = 'A' AND ESLCD = BJRDNB) OR
     C**********                   (PMode = 'L' AND ESRECI = 'D')                           AR988376
     C                             (PMode = 'R' AND ESRECI = 'D')                           AR988376
      *
     C                   READ      SDOPESL0
      *
     C                   IF        NOT %EOF(SDOPESL0)
      *
      ** Count no. of records processed
      *
     C                   EVAL      WNoRec = WNoRec + 1
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print details report                                *
      *                                                               *
      * Called by: SRProces                                           *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
      *
     C                   IF        NOT %OPEN(SD001247P1)
     C                   OPEN      SD001247P1
      *
      ** Ensure Detail Spool File recorded by RCF
      *
     C                   EVAL      PZSNum = SFNum1
     C                   EVAL      PSFile = SFile1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      PrtLn1 = 59
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
      *
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADER
     C                   EVAL      WFirst = 'N'
     C                   ENDIF
      *
      ** Last Change Date/Type
      *
     C                   SELECT
     C                   WHEN      ESCHTP = 'I'
     C                   EVAL      WESCHTP = 'INSERT'
     C                   WHEN      ESCHTP = 'A'
     C                   EVAL      WESCHTP = 'AMEND'
     C                   WHEN      ESCHTP = 'D'
     C                   EVAL      WESCHTP = 'DELETE'
     C                   END
      *
      ** Write Detail Format
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - Print trailer for end of report                       *
      *                                                               *
      * Called by: SRProces                                           *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
      *
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OflLn1 - PrtLn1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER
     C                   ENDIF
      *
      ** Write out report trailer
      *
     C                   WRITE     TRAILER
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRControl - Subroutine to check and compare control file      *
      *                                                               *
      * Called by: SRAudit                                            *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     SRControl     BEGSR
      *
      ** Check control details
      *
     C                   EVAL      WFName = 'SDOPESPD'
     C     WFName        CHAIN     SDFCTLL1                           55
      *
      ** Database error
      *
     C                   IF        *IN55 = '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WFName
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
      *
     C                   IF        RCOUNT <> RAUDIT
      *
      ** File Out Of Balance - SETON U8
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Print audit report                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ZSFILE, SRControl                                      *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
     C                   OPEN      SD001247AU
      *
      ** Ensure Audit Spool File recorded by RCF
      *
     C                   EVAL      PZSNum = SFNumU
     C                   EVAL      PSFile = SFileU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
      *
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** If there is a record read, write audit control report
      *
     C                   IF        WNoRec <> 0
      *
      ** Check then write control details
      *
     C                   EXSR      SRControl
     C                   WRITE     CONTROL
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message
      *
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Close Audit Printer File & Report File
      *
     C                   IF        %OPEN(SD001247P1)
     C                   CLOSE     SD001247P1
     C                   ENDIF
      *
     C                   IF        %OPEN(SD001247AU)
     C                   CLOSE     SD001247AU
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: none                                               *
      *                                                               *
      * Calls: none                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    Prtcd                                      AR988376
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
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
      * Calls: SRAudit                                                *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
