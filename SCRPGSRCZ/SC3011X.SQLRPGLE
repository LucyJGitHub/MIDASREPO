     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055681
/*STD *  RPGSQLBND                                                    *                     MD055681
/*EXI *  TEXT('Midas SC Add background switchable feature')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3011X - Insert/Delete Background Switchable Feature.       *
      *                                                               *
      *  Function:  This program inserts or deletes a switchable      *
      *             feature to reflect a data setting such as a       *
      *             flag on an ICD file.                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 12Oct98               *
      *                 S01486             Date 19OCT94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  S01486 - New program created to allow ICD options to         *
      *           control access to menu items, cob components etc.   *
      *                                                               *
      *****************************************************************
     F*SCSARDL0* UF A E           K DISK    USROPN                                          MD054681
     F**********                           INFDS(ID0001)                                    MD055681
     F**********                           INFSR(*PSSR)                                     MD055681
      * UPD : Switchable Features    res in system update
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D ID0001          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I :  Action Code
     D  P1ANCD                 1      1
     D P2PARM          DS
      * I :  Switchable Feature Number
     D  P2SARN                 1      6
     D P3PARM          DS
      * I :  Description
     D  P3SARD                 1     50
     D P4PARM          DS
      * O :  Return code
     D  P4BSCD                 1      6
     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
     D                                     PREFIX(AB)                                       MD055681
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ANCD        PARM                    WP0001            1            Action Code
     C     P2SARN        PARM                    WP0002            6            Switchable Feat
     C     P3SARD        PARM                    WP0003           50            Description
     C     P4BSCD        PARM      P4BSCD        WP0004            6            Return code
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Add Background Feature
      * SC3011X Precompiler - Switchable Features  *
      * Copyright Statement 1994 - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
      * Initialise work fields.
     C                   MOVEL     P2SARN        WUSARN                         Switchable Feat
     C                   MOVEL     P3SARD        WUSARD                         Description
     C                   Z-ADD     *ZERO         WULCD                          Last change dat
     C                   MOVEL     'I'           WUTYLC                         Type of the Las
     C                   MOVEL     *BLANK        WUAANA                         midas rundate
      * Insert mode processing.
      * CASE: PAR.Action Code is Insert
     C     P1ANCD        IFEQ      'I'                                          *IF
      * Create Background Feature - Switchable Features  *
     C                   EXSR      SACRRC
     C                   END                                                    *FI
      * Delete mode processing.
      * CASE: PAR.Action Code is Delete
     C     P1ANCD        IFEQ      'D'                                          *IF
      * Delete Background Feature - Switchable Features  *
     C                   EXSR      SBDLRC
     C                   END                                                    *FI
      * Move program return code to return code parameter.
     C                   MOVEL     W0RTN         P4BSCD                         Return code
      *----------------------------------------------------------------
      * Exit program
     C     AAEXIT        TAG
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Background Feature - Switchable Features  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @SARDL0
     C                   MOVEL     WUSARN        ABSARN                         Switchable Feat
     C                   MOVEL     WUSARD        ABSARD                         Description
     C                   Z-ADD     WUAKTX        ABLCD                          Last change dat
     C                   MOVEL     'I'           ABTYLC                         Type of the Las
      *
      * USER: Processing before Data update
     C     KLCRSA        KLIST
     C                   KFLD                    ABSARN                         Switchable Feat
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @SARDL0                                90    *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       90                    MD055681
     C                   IF        SQLCODE = 0                                              MD055681
     C                   SETON                                        90                    MD055681
     C                   ENDIF                                                              MD055681
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CBM0005'     W0RTN             7
      * Send message 'Switchable Features  EX'
     C                   MOVEL     'CBM0005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   END
      *
     C***********        WRITE     @SARDL0                              91      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDBTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , SARD                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABSARD                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , :ABTYLC                                                                           MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ insert into SCSRDXTD                                                                MD055681
     C+ (                                                                                   MD055681
     C+   SARN                                                                              MD055681
     C+ , LCD                                                                               MD055681
     C+ , TYLC                                                                              MD055681
     C+ , ZONE                                                                              MD055681
     C+ , ENABLD                                                                            MD055681
     C+ , MODE                                                                              MD055681
     C+ )                                                                                   MD055681
     C+ Values                                                                              MD055681
     C+ (                                                                                   MD055681
     C+   :ABSARN                                                                           MD055681
     C+ , :ABLCD                                                                            MD055681
     C+ , :ABTYLC                                                                           MD055681
     C+ , ' '                                                                               MD055681
     C+ , 'E'                                                                               MD055681
     C+ , 'B'                                                                               MD055681
     C+ )                                                                                   MD055681
     C/END-EXEC                                                                             MD055681
      *
     C******IN91         IFEQ      '1'                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBDLRC        BEGSR
      *================================================================
      * Delete Background Feature - Switchable Features  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @SARDL0
     C                   MOVEL     WUSARN        ABSARN                         Switchable Feat
      *
     C     KLDLSB        KLIST
     C                   KFLD                    ABSARN                         Switchable Feat
     C*****KLDLSB        CHAIN     @SARDL0                            9091      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :SCSARD                                                                        MD055681
     C+ from SCSRDJW0                                                                       MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       9091                  MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   SETON                                        90                    MD055681
     C                   ENDIF                                                              MD055681
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055681
     C                   SETON                                        91                    MD055681
     C                   ENDIF                                                              MD055681
     C     *IN90         IFEQ      '1'
      * Record already deleted
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
      * Send message '*Database operation error'
     C                   MOVEL     'Y2U0004'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
      *................................................................
     C**********         DELETE    @SARDL0                              91      *           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDBTD                                                                MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete from SCSRDXTD                                                                MD055681
     C+ where SARN = :ABSARN                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C******IN91         IFEQ      '1'                                                      MD055681
     C                   IF        SQLCODE <> 0                                             MD055681
      * Delete error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Define work field Switchable Feature Number
     C                   MOVEL     *BLANK        WUSARN            6
      * Define work field Description
     C                   MOVEL     *BLANK        WUSARD           50
      * Define work field Last change date  LCD
     C                   Z-ADD     *ZERO         WULCD             5 0
      * Define work field Type of the Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      * Obtain default message file
     C     *DTAARA       DEFINE    CBMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C**********         OPEN      SCSARDL0                                                 MD055681
     C                   MOVEL     'N'           W0PMT             1
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SC3011XPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3011XPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD055681
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055681
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3011XPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
