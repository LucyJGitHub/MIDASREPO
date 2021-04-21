     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*XBIA*  OVRDBF FILE(REPPJSPDN) TOFILE(REPPJSPD) SHARE(*NO)           *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE On-Line Synch. of RSACMTPD, APOST, GLACPH')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004001 - On-Line Synch. of RSACMTPD, APOSTPD & GLACPHPD    *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE072  *CREATE    Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *                                                               *
      *****************************************************************
      *
      ** Midas GL Account Movements - Full Accnt Order
     FZTACMTL0  UF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas RE Passbook Printing Status File
     FREPPSTL0  UF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas RE Passbook Update Control Detail
     FPBUDCPD   UF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas GL Account details - full a/c number
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas GL Account posting
     FGLPOSTL6  UF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas GL Accounts Post Historic Details
     FGLACPHL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PD_)
     F                                     RENAME(APOSTPDF:GLACPHD0)
      *
      ** Midas RE Passbook Printing Journal Seq.No.
     FREPPJSPD  UF   E             DISK    INFSR(*PSSR) COMMIT
     FREPPJSPDN UF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(REPPJSD0:REPPJSDN)
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
      *
      ** Maximum number of files
      *
     D MaxNoFils       C                   CONST(200)
      *
      ** File arrays
      *
     D #_ZPF           S             10    DIM(MaxNoFils)
     D #_PBEF          S              1    DIM(MaxNoFils)
      *
     D WRun            S              1A
     D  I#AIMG         S           4000
     D  I#ZONE         S             10
     D  I#RTCD         S              7
     D  I#ERMS         S             50
     D  CountEntries   S              3  0
     D  ACTNO_APGL     S             10  0
     D  ACTNO_RSAC     S             10  0
     D  POptn          S              7A
     D  PRtCd          S              7A
     D  KDRCR          S              1S 0
     D  KTREF1         S             20A
      *
     D JournalEnt      DS
      *
      ** Standard fields on all journal entries
      *
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler03                     11A
     D  CommitId                     10A
     D  Filler04                      8A
      *
      ** Fields specific to the journal entry
      *
     D  EntryData                  4000A
      *
     D ControlInf      DS
     D  CTRLInfo1                     1
      *
     D                 DS
     D  MsgInfo                1    131
     D  Instruction            1      5
     D  KBRCA                 25     27
     D  KCUSN                 28     33
     D  KACTCODE              34     43S 0
     D  KACTSEQ               44     45S 0
     D  KCCYCODE              46     48
     D  KTREF                 52     72
     D  KACTION               83     83
     D  PrtFlag              115    115
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
      *
     C                   MOVEL     EntryData     MsgInfo
      *
      ** If the first byte of Control Information is 0, no data has been
      ** passed so simply return
      *
     C                   IF        CTRLInfo1 = '0'
     C                   RETURN
     C                   ENDIF
      *
      ** If the journal receiver has been changed
      *
     C                   IF        JrnEntType = 'NR'
     C                   EXSR      UPD_COM_OSJS
     C                   EVAL      CTRLInfo1 = '9'
     C                   SETON                                        U6LR
     C                   RETURN
     C                   ENDIF
      *
      ** PROCESS ENTRY
      ** =============
      *
     C                   SELECT
      *
      ** Ignore journal entries generated by this function
      *
     C                   WHEN       Program = 'RE004001'
     C                   EXSR      UPD_NCOM_OSJS
      *
      ** If this is an 'END' entry,
      ** tell the RCVJRNE command (and hence the controlling CL) to stop
      *
     C                   WHEN      JrnEntType = 'OS'
     C                             AND Instruction = 'END  '
     C                   EXSR      UPD_COM_OSJS
     C                   EVAL      CTRLInfo1 = '9'
      *
      ** If this is an update entry, then action it
      *
     C                   WHEN      JrnEntType = 'PT'
     C                             OR JrnEntType = 'PX'
     C                             OR JrnEntType = 'UP'
     C                   EXSR      ACTN_UPDATE
     C                   EXSR      UPD_COM_OSJS
      *
     C                   ENDSL
      *
     C                   RETURN
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Action update
      *********************************************************************
     C     ACTN_UPDATE   BEGSR
      *
     C                   MOVEL     *BLANK        I#AIMG
      *
      ** Apply updates for the 'after' status
      *
     C                   IF        JrnEntType = 'PT'
     C                             OR JrnEntType = 'PX'
     C                             OR JrnEntType = 'UP'
     C                   MOVEL     EntryData     I#AIMG
     C                   EXSR      RECD_Updates
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update REPPJSPD
      ********************************************************************
     C     UPD_COM_OSJS  BEGSR
      *
      ** Change the sequence number reached on the journal
      *
     C     1             CHAIN     REPPJSD0                           99
     C                   IF        *IN99 = *OFF
     C                   EVAL      JSLSEQ = JrnSeqn
     C                   IF        JrnEntType = 'NR'
     C                   Eval      JSLRCV = MsgInfo
     C                   EndIf
     C                   UPDATE    REPPJSD0
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON ACCESS OF REPPJSPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Commit the updates
      *
     C                   COMMIT
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update REPPJSPD with no commit
      ********************************************************************
     C     UPD_NCOM_OSJS BEGSR
      *
      ** Only update on every 100th entry
      *
     C                   IF        CountEntries = 100
     C                             OR JrnEntType = 'NR'
      *
      **Change the sequence number reached on the journal
      *
     C     1             CHAIN     REPPJSDN                           99
     C                   IF        *IN99 = *OFF
     C                   EVAL      JSLSEQ = JrnSeqn
     C                   IF        JrnEntType = 'NR'
     C                   Eval      JSLRCV = MsgInfo
     C                   EndIf
     C                   UPDATE    REPPJSDN
     C                   ELSE
     C                   EVAL      I#ERMS   = 'ERROR ON ACCESS OF REPPJSPD'
     C                   EVAL      CTRLInfo1 = '9'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     0             CountEntries
     C                   ELSE
     C                   ADD       1             CountEntries
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Record updates
      *********************************************************************
     C     RECD_Updates  BEGSR
      *
     C                   EVAL      ACTNO_APGL = 0
     C                   EVAL      ACTNO_RSAC = 0
     C                   MOVEL     KAction       KDRCR
     C                   EVAL      KTREF1 = KTREF
      *
     C                   IF        PrtFlag = 'Y'
     C                   EXSR      RECD_Updates_Y
     C                   ELSEIF    PrtFlag = 'N'
     C                   EXSR      RECD_Updates_N
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Record updates on 'Y' scenario
      *********************************************************************
     C     RECD_Updates_YBEGSR
      *
      ** Update RSACMTPD.APBI to 'Y' if current value is 'N', otherwise no change.
      *
     C     KRSAC         CHAIN     ZTACMTL0
     C                   IF        %Found(ZTACMTL0)
     C                   IF        APBI <> 'Y'
     C                   EVAL      APBI = 'Y'
     C                   UPDATE    RSACMTPO
     C                   ENDIF
     C                   EXSR      PBUD_RSAC_UPD
     C                   ELSE
      *
      ** Update APOSTPD.PRIN to 'Y' if current value is 'N', otherwise no change.
      *
     C     KAPOS         CHAIN     GLPOSTL6
     C                   IF        %Found(GLPOSTL6)
     C                   TESTB     '3'           PRIN                     10
     C                   IF        *IN10 = *OFF
     C                   BITON     '3'           PRIN
     C                   UPDATE    APOSTPDF
     C                   ENDIF
     C                   EVAL      ACTNO_APGL = ACNO
     C                   EXSR      PBUD_APGL_UPD
     C                   ELSE
      *
      ** Update GLACPHPD.PRIN to 'Y' if current value is 'N', otherwise no change.
      *
     C     KAPOS         CHAIN     GLACPHL3
     C                   IF        %Found(GLACPHL3)
     C                   TESTB     '3'           PD_PRIN                  11
     C                   IF        *IN11 = *OFF
     C                   BITON     '3'           PD_PRIN
     C                   UPDATE    GLACPHD0
     C                   ENDIF
     C                   EVAL      ACTNO_APGL = ACNO
     C                   EXSR      PBUD_APGL_UPD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Delete Record in Passbook Printing Status File.
      *
     C                   IF        PPLLFL = 'N'
     C                   EXSR      Del_REPP
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Record updates on 'N' scenario
      *********************************************************************
     C     RECD_Updates_NBEGSR
      *
      ** Update RSACMTPD.APBI to 'N' if current value is 'Y', otherwise no change.
      *
     C     KRSAC         CHAIN     ZTACMTL0
     C                   IF        %Found(ZTACMTL0)
     C                   IF        APBI <> 'N'
     C                   EVAL      APBI = 'N'
     C                   UPDATE    RSACMTPO
     C                   ENDIF
     C                   EXSR      PBUD_RSAC_UPD
     C                   ELSE
      *
      ** Update APOSTPD.PRIN to BITOFF '3' if current value is ON.
      *
     C     KAPOS         CHAIN     GLPOSTL6
     C                   IF        %Found(GLPOSTL6)
     C                   TESTB     '3'           PRIN                     10
     C                   IF        *IN10 = *ON
     C                   BITOFF    '3'           PRIN
     C                   UPDATE    APOSTPDF
     C                   ENDIF
     C                   EVAL      ACTNO_APGL = ACNO
     C                   EXSR      PBUD_APGL_UPD
     C                   ELSE
      *
      ** Update GLACPHPD.PRIN to BITOFF '3' if current value is ON, otherwise no change.
      *
     C     KAPOS         CHAIN     GLACPHL3
     C                   IF        %Found(GLACPHL3)
     C                   TESTB     '3'           PD_PRIN                  11
     C                   IF        *IN11 = *ON
     C                   BITOFF    '3'           PD_PRIN
     C                   UPDATE    GLACPHD0
     C                   ENDIF
     C                   EVAL      ACTNO_APGL = ACNO
     C                   EXSR      PBUD_APGL_UPD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Delete record found on REPPSTPD
      *********************************************************************
     C     Del_REPP      BEGSR
      *
     C     KREPP         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCUSN
     C                   KFLD                    KACTCODE
     C                   KFLD                    KACTSEQ
     C                   KFLD                    KCCYCODE
     C                   KFLD                    KTREF
      *
     C     KREPP         CHAIN     REPPSTL0
     C                   IF        %Found
     C                   DELETE    REPPSTD0
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update record on PBUDCPD on APOSTPD and GLACPHPD
      *********************************************************************
     C     PBUD_APGL_UPD BEGSR
      *
     C     ACTNO_APGL    CHAIN     PBUDCPD
     C                   IF        %FOUND
     C                   EVAL      SPBL = PPSTLN
     C                   EVAL      CFPB = PPCFWB
     C                   EVAL      PSTD = PPPSDT
     C                   UPDATE    PBUDCPDF
      *
     C                   ELSE
      *
     C                   CALL      'RE004248'
     C                   PARM      '*NEW   '     POptn
     C                   PARM                    KCUSN
     C                   PARM                    KCCYCODE
     C                   PARM                    KACTCODE
     C                   PARM                    KACTSEQ
     C                   PARM                    KBRCA
     C                   PARM      *BLANKS       PRtCd
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'RE004248'
     C                   EVAL      DBASE  =  6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Update record on PBUDCPD on RSACMTPD
      *********************************************************************
     C     PBUD_RSAC_UPD BEGSR
      *
      ** Get the Retail Account Number from ACCNTAB.
      *
     C     KACCT         CHAIN     ACCNTABF
     C                   IF        %FOUND
     C                   EVAL      ACTNO_RSAC = ACNO
     C                   ENDIF
      *
      ** Update the Passbook Control Detail.
      *
     C     ACTNO_RSAC    CHAIN     PBUDCPD
     C                   IF        %FOUND(PBUDCPD)
     C                   EVAL      SPBL = PPSTLN
     C                   EVAL      CFPB = PPCFWB
     C                   EVAL      PSTD = PPPSDT
     C                   UPDATE    PBUDCPDF
      *
     C                   ELSE
      *
     C                   CALL      'RE004248'
     C                   PARM      '*NEW   '     POptn
     C                   PARM                    KCUSN
     C                   PARM                    KCCYCODE
     C                   PARM                    KACTCODE
     C                   PARM                    KACTSEQ
     C                   PARM                    KBRCA
     C                   PARM      *BLANKS       PRtCd
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'RE004248'
     C                   EVAL      DBASE  =  6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
      *
     C                   MOVE      *BLANK        I#RTCD
     C                   MOVE      *BLANK        I#ERMS
      *
     C     KACCT         KLIST
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCYCODE
     C                   KFLD                    KACTCODE
     C                   KFLD                    KACTSEQ
     C                   KFLD                    KBRCA
     C     KRSAC         KLIST
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCYCODE
     C                   KFLD                    KACTSEQ
     C                   KFLD                    KBRCA
     C                   KFLD                    KDRCR
     C                   KFLD                    KACTCODE
     C                   KFLD                    KTREF1
     C     KAPOS         KLIST
     C                   KFLD                    KCUSN
     C                   KFLD                    KCCYCODE
     C                   KFLD                    KACTSEQ
     C                   KFLD                    KDRCR
     C                   KFLD                    KBRCA
     C                   KFLD                    KACTCODE
     C                   KFLD                    KTREF
      *
      ** Job details
      ** Load files for on-line synchronisation
      *
     C                   Z-ADD     0             CountEntries
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
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
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      PRtCd = '*ERROR'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
**  CPY@
(c) Finastra International Limited 2011
