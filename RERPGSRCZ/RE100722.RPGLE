     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Group A/c Shadow Posting Replication')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100722  - Group A/c Shadow Posting Replication             *
      *                                                               *
      *  Function:  This module reads entries on RSACMTPD just prior  *
      *             to input cycle. For each entry it calls RE101601  *
      *             to determine if the entry is across a sub-account *
      *             in a group a/c hierarchy. If it is, it is         *
      *             replicated up the hierarchy.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP205             Date 08Mar10               *
      *  Prev Amend No. CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRSACMTPD  IP   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
 
      ** Group A/c Shadow Posting Replication - Audit
     FRE100722AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Entry To Replicate
     D I_RSACMT      E DS                  EXTNAME(RSACMTPD)
     D                                     PREFIX(R_)
 
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D JournalEnt      DS
      * Standard fields on all journal entries
     D  Filler01                      5A
     D  JrnSeqn                      10A
     D  JrnCode                       1A
     D  JrnEntType                    2A
     D  Filler02                     38A
     D  Program                      10A
     D  Object                       10A
     D  Library                      10A
     D  Member                       10A
     D  Filler03                     29A
      * The journal entry
     D  Entry                       500A
 
     D ControlInf      DS
     D  CTRLInfo1                     1
     D  CTRLInfo2                     1
 
 
 
      ** File Information Data Structure for RE100722AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
 
      /SPACE 5
 
     C                   EVAL      Object = 'RSACMTPD'
     C                   EVAL      Entry = I_RSACMT
     C                   ADD       1             RCOUNT1           5 0
 
      * Group A/c Shadow Posting Replication
 
     C                   CALL      'RE101601'
     C                   PARM                    JournalEnt
     C                   PARM                    ControlInf
 
      * If failure
 
     C                   IF        CTRLInfo1 = '9'
     C                   EVAL      X_ERMS = 'GROUP A/C SHADOW POSTING ' +
     C                                      'REPLICATION FAILED'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Produce the Audit Report
 
     CLR                 EXSR      SRAudit
 
      /SPACE 5
      *****************************************************************
      * SRAudit - Write the Audit Report                              *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   WRITE     HEADAU
     C                   WRITE     HASRUN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I_JRNSQ          10 0
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Initialize entry details
 
     C                   MOVEL     I_JRNSQ       JrnSeqn
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
