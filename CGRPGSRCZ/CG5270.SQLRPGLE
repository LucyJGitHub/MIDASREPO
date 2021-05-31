     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
     H*CVTOPT*(*GRAPHIC)***********************************************            MD054955 MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG UDC charge processing')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                  *
     F*                                                               *
     F*  CG5270 - UDC Charge Processing                               *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: CGC5270 - UDC Charge Processing                   *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD054955           Date 16Dec19               *
      *                 253062             Date 18Apr18               *
      *                 MD046248           Date 27Oct17               *
      *                 CCG024             Date 29Sep16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 13Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 03Feb95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  253062 - UDC_Charge not releasing record locks on file       *
      *           CGUDCLPD.                                           *
      *         - Applied for MD-50387.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CCG015 - Correspondence Manager Phase 1 (Recompile)          *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG5270DFPG
     FCGUDCLL2  UF   E           K DISK
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      *
      * RSQ : UDC Log records           Charges to be calculated
      *
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRL4  IF   E           K DISK    INFSR(SRFILE)
      *
      * RTV : Correspondent Details     By Correspondent
      *
     FCGUDCRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * RTV : UDC Reference             By Item/dest.correspondent
      *
     F*CGCSCHL5* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RSQ : Correspondent Schedules   By Primary Correspondent
      *
     F*CGCSCHL3* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RTV : Correspondent Schedule    By Account
      *
     F*CGCSCHL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RTV : Correspondent Schedule    By Account code
      *
     FCGCORRL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * RSQ : Correspondent Details     System and Branches
      *
     FCGCORRLC  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * RSQ : Correspondent Details     By Correspondent Types
      *
     F*CGCSCHL0* UF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F**********                           COMMIT                                           MD054955
      *
      * UPD : Correspondent Schedules   Update Index
      *
     FCGCORRL0  UF   E           K DISK
     F                                     INFSR(SRFILE)
     F                                     COMMIT
      *
      * UPD : Correspondent Details     Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
      *                                                                                       CSC022
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG5270DEPG
      /EJECT
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG5270DIPG
      /EJECT
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * Switchable Features Details accessed via Access Program                               CSC022
      *                                                                                       CSC022
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
      /EJECT
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      * Data structure for AOSVALR0 string                                                    CCG024
     D                 DS
     D  SVAL1                  1    200
     D  SVAL11                 1      1
      *                                                                                       CCG024
      * System Value                                                                          CCG024
     D                 DS
     D  SVALK1                 1     20    INZ('RecipientSpecialChar')
      *                                                                                       CCG024
      *
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  Read all records on the log file indicating charges
      *  to be calculated
      *
     C     *LOVAL        SETLL     @UDCLL2
     C                   READ      @UDCLL2                                91
     C     *IN91         DOWEQ     '0'
      *
      * Get UDC Reference record
      *
     C     KUDCR         KLIST
     C                   KFLD                    DRITEM
     C                   KFLD                    DRDCOR
      *
     C                   Z-ADD     DLITEM        DRITEM
     C                   MOVEL     DLDCOR        DRDCOR
      *
     C     KUDCR         CHAIN     @UDCRL1                            90
      *
      *  If not found error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGUDCRL1'    W0FILE
     C                   MOVEL     DRITEM        ##008A            8
     C     ##008A        CAT       DLDCOR        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Set up Print Item Type and Sub-type variables
      *
     C     *LIKE         DEFINE    DRPTYP        ##PTYP
     C     *LIKE         DEFINE    DRPSTP        ##PSTP
     C     *LIKE         DEFINE    CPPCOR        ##PCOR
     C     *LIKE         DEFINE    CPCORR        ##DCOR
     C                   MOVEL     DRPTYP        ##PTYP
     C                   MOVEL     DRPSTP        ##PSTP
      *
      * Calculate charges for correspondent
      *
     C                   EXSR      SRCORR
      *
      * Calculate charges for Correspondent Type
      *
     C                   EXSR      SRCTYP
      *
      * Calculate charges for Branch
      *
     C                   EXSR      SRBRCH
      *
      * Calculate charges for System
      *
     C                   EXSR      SRSYSM
      *
      *  Update message to charges calculated and commit
      *
     C                   MOVEL     'CGD1805'     DLMSID
     C                   TIME                    DLATIM
     C                   EXCEPT    UDCLL2
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
      *
      *  Read next record
      *
     C                   READ      @UDCLL2                                91
     C                   ENDDO
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCORR   : Calculate Correspondent Charges                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCORR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCORR'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG5270CORR
      *
      *  Get correspondent record
      *
     C     KCORR         KLIST
     C                   KFLD                    CDCORR
      *
     C                   MOVEL     DLDCOR        CDCORR
      ** If feature CCG024 is on and special character is found in DRDCOR                     CCG024
     C                   MOVEL     'N'           XFOUND            1
     C     CCG024        IFEQ      'Y'
     C     SVAL11        SCAN      CDCORR                                 99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     CDCORR        XXCORR            6
     C     XXCORR        CHAIN     CGCORRL4                           51
     C     *IN51         IFEQ      *ON
     C                   MOVEL     'CGCORRL4'    W0FILE
     C                   MOVEL     CDCORR        W0KEY                          ***************
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   MOVEL     'Y'           XFOUND
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CCG024
     C     XFOUND        IFEQ      'N'
     C     KCORR         CHAIN     @CORRL1                            90
      *
      *  If not found error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGCORRL1'    W0FILE
     C                   MOVEL     DLDCOR        W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ENDIF
      *
      *  Call subroutine to access and update schedules
      *
     C                   MOVEL     DRPCOR        ##PCOR
     C                   MOVEL     DRDCOR        ##DCOR
     C                   EXSR      SRCSCH
      *
      *  Unwind subroutine stack name
      *
     C     EXCORR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCTYP   : Calculate Correspondent Type Charges              *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCTYP        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCTYP'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG5270CTYP
      *
      *  Get correspondent type record
      *
     C     KCTYP         KLIST
     C                   KFLD                    CDCTYP
      *
     C     KCTYP         CHAIN     @CORRLC                            90
      *
      *  If found
      *
     C     *IN90         IFEQ      '0'
      *
      *  Call subroutine to access and update schedules
      *
     C                   MOVEL     CDCORR        ##PCOR
     C                   MOVEL     CDCORR        ##DCOR
     C                   EXSR      SRCSCH
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXCTYP        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCORR   : Calculate Branch Charges                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRBRCH        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRBRCH'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG5270BRCH
      *
      *  Get branch record
      *
     C     KBRCH         KLIST
     C                   KFLD                    DRBRCA
      *
     C     KBRCH         CHAIN     @CORRL3                            90
      *
      *  If found
      *
     C     *IN90         IFEQ      '0'
      *
      *  Call subroutine to access and update schedules
      *
     C                   MOVEL     CDCORR        ##PCOR
     C                   MOVEL     CDCORR        ##DCOR
     C                   EXSR      SRCSCH
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXBRCH        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSYSM   : Calculate System Charges                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRSYSM        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSYSM'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG5270SYSM
      *
      *  Get branch record
      *
     C     *LIKE         DEFINE    DRBRCA        ##BRCA
     C     KBRCH2        KLIST
     C                   KFLD                    ##BRCA
      *
     C                   MOVEL     *BLANKS       ##BRCA
     C     KBRCH2        CHAIN     @CORRL3                            90
      *
      *  If found
      *
     C     *IN90         IFEQ      '0'
      *
      *  Call subroutine to access and update schedules
      *
     C                   MOVEL     CDCORR        ##PCOR
     C                   MOVEL     CDCORR        ##DCOR
     C                   EXSR      SRCSCH
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXSYSM        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCSCH   : Access Schedules for update                       *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCSCH        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCSCH'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG5270CSCH
      *
      *  If account specified then look for schedule
      *
     C     KCSHL3        KLIST
     C                   KFLD                    CPMACT
     C                   KFLD                    CPCORR
     C                   KFLD                    CPPTYP
     C                   KFLD                    CPPSTP
      *
     C                   MOVEL     DRMACT        CPMACT
     C                   MOVEL     ##DCOR        CPCORR
     C                   MOVEL     ##PTYP        CPPTYP
     C                   MOVEL     ##PSTP        CPPSTP
      *
      *  Access L3 to see if record exists
      *
     C*****KCSHL3        SETLL     @CSCHL3                                                  MD054955
     C*****KCSHL3        READE     @CSCHL3                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPMACT = :CPMACT and CPCORR = :CPCORR and CPPTYP = :CPPTYP                    MD054955
     C+ and CPPSTP = :CPPSTP and CPRECI = 'D' and CPMACT <> '          '                    MD054955
     C+ order by CPMACT, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If found and currency
      *
     C     *IN90         IFEQ      '0'
     C     CPCCCY        ANDNE     *BLANKS
     C     CPACHG        ANDNE     'S'
      *
      *  Add charge update and exit
      *
     C     KFULL         KLIST
     C                   KFLD                    CPCORR
     C                   KFLD                    CPPTYP
     C                   KFLD                    CPPSTP
     C                   KFLD                    CPSEQN
      *
     C*****KFULL         CHAIN     @CSCHL0                            90                    MD054955
      *
     C                   ADD       CPCITM        CPBSNB
     C*********          EXCEPT    CSCHL0                                                   MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPBSNB = :CPBSNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   GOTO      EXCSCH
     C                   ENDIF
      *
      *  If account specified then look for schedule by account
      *
     C     KCSHL2        KLIST
     C                   KFLD                    CPACCD
     C                   KFLD                    CPCORR
     C                   KFLD                    CPPTYP
     C                   KFLD                    CPPSTP
      *
     C********** 4         SUBSTDRMACT:10 CPACCD    P                                         CGL029
     C     10            SUBST(P)  DRMACT:10     CPACCD
     C                   MOVEL     ##DCOR        CPCORR
     C                   MOVEL     ##PTYP        CPPTYP
     C                   MOVEL     ##PSTP        CPPSTP
      *
      *  Access L2 to see if record exists
      *
     C*****KCSHL2        SETLL     @CSCHL2                                                  MD054955
     C*****KCSHL2        READE     @CSCHL2                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPACCD = :CPACCD and CPCORR = :CPCORR and CPPTYP = :CPPTYP                    MD054955
     C+ and CPPSTP = :CPPSTP and CPRECI = 'D' and CPACCD <> '          '                    MD054955
     C+ order by CPACCD, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If found and currency
      *
     C     *IN90         IFEQ      '0'
     C     CPCCCY        ANDNE     *BLANKS
     C     CPACHG        ANDNE     'S'
      *
      *  Add charge update and exit
      *
     C*****KFULL         CHAIN     @CSCHL0                            90                    MD054955
      *
     C                   ADD       CPCITM        CPBSNB
     C************       EXCEPT    CSCHL0                                                   MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPBSNB = :CPBSNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   GOTO      EXCSCH
     C                   ENDIF
      *
      *  Get full details
      *
     C     KCSCH         KLIST
     C                   KFLD                    CPPCOR
     C                   KFLD                    CPPTYP
     C                   KFLD                    CPPSTP
     C                   KFLD                    CPCORR
      *
     C                   MOVEL     ##PCOR        CPPCOR
     C                   MOVEL     ##PTYP        CPPTYP
     C                   MOVEL     ##PSTP        CPPSTP
     C                   MOVEL     ##DCOR        CPCORR
      *
     C*****KCSCH         SETLL     @CSCHL5                                                  MD054955
     C*****KCSCH         READE     @CSCHL5                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPPCOR = :CPPCOR  and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                   MD054955
     C+ and CPCORR = :CPCORR and CPRECI = 'D'                                               MD054955
     C+ order by CPPCOR, CPPTYP, CPPSTP, CPCORR, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If found and currency
      *
     C     *IN90         IFEQ      '0'
     C     CPCCCY        ANDNE     *BLANKS
     C     CPACHG        ANDNE     'S'
      *
      *  Add charge update and exit
      *
     C*****KFULL         CHAIN     @CSCHL0                            90                    MD054955
      *
     C                   ADD       CPCITM        CPBSNB
     C************       EXCEPT    CSCHL0                                                   MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPBSNB = :CPBSNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   GOTO      EXCSCH
     C                   ENDIF
      *
      *  Get partial details
      *
     C                   MOVEL     ##PCOR        CPPCOR
     C                   MOVEL     ##PTYP        CPPTYP
     C                   MOVEL     *BLANKS       CPPSTP
     C                   MOVEL     ##DCOR        CPCORR
      *
     C*****KCSCH         SETLL     @CSCHL5                                                  MD054955
     C*****KCSCH         READE     @CSCHL5                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPPCOR = :CPPCOR  and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                   MD054955
     C+ and CPCORR = :CPCORR and CPRECI = 'D'                                               MD054955
     C+ order by CPPCOR, CPPTYP, CPPSTP, CPCORR, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If found and currency
      *
     C     *IN90         IFEQ      '0'
     C     CPCCCY        ANDNE     *BLANKS
     C     CPACHG        ANDNE     'S'
      *
      *  Add charge update and exit
      *
     C*****KFULL         CHAIN     @CSCHL0                            90                    MD054955
      *
     C                   ADD       CPCITM        CPBSNB
     C************       EXCEPT    CSCHL0                                                   MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPBSNB = :CPBSNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   GOTO      EXCSCH
     C                   ENDIF
      *
      *  Get default details
      *
     C                   MOVEL     ##PCOR        CPPCOR
     C                   MOVEL     *BLANKS       CPPTYP
     C                   MOVEL     *BLANKS       CPPSTP
     C                   MOVEL     ##DCOR        CPCORR
      *
     C*****KCSCH         SETLL     @CSCHL5                                                  MD054955
     C*****KCSCH         READE     @CSCHL5                                90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGCSCH                                                                        MD054955
     C+ from CGCSHJW0                                                                       MD054955
     C+ where CPPCOR = :CPPCOR  and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                   MD054955
     C+ and CPCORR = :CPCORR and CPRECI = 'D'                                               MD054955
     C+ order by CPPCOR, CPPTYP, CPPSTP, CPCORR, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If found and currency
      *
     C     *IN90         IFEQ      '0'
     C     CPCCCY        ANDNE     *BLANKS
     C     CPACHG        ANDNE     'S'
      *
      *  Add charge update and exit
      *
     C*****KFULL         CHAIN     @CSCHL0                            90                    MD054955
      *
     C                   ADD       CPCITM        CPBSNB
     C************       EXCEPT    CSCHL0                                                   MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPBSNB = :CPBSNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   GOTO      EXCSCH
     C                   ENDIF
      *
      *  If Correspondent and currency
      *
     C     CDCCCY        IFNE      *BLANKS
     C     CPACHG        ANDNE     'S'
      *
      *  Add charge update and exit
      *
     C     KCORR         CHAIN     @CORRL0                            90
      *
     C                   ADD       CDCITM        CDBSNB
     C                   EXCEPT    CORRL0
     C                   GOTO      EXCSCH
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXCSCH        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG5270INIT
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CSC022'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                51
     C********** *IN50     IFEQ *ON                                                    CSC022 253062
     C     *IN51         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     P@RTCD        IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     6             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C     *LIKE         DEFINE    SARN          P@SARD
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'
     C                   PARM                    P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CCG024'      P@SARD
      *                                                                                       CCG024
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG024            1
     C                   ELSE
     C                   MOVE      'N'           CCG024
     C                   ENDIF
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C     CCG024        IFEQ      'Y'
      *                                                                                       CCG024
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM      *BLANKS       SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM      *BLANKS       SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM      *BLANKS       SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM      *BLANKS       SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM      *BLANKS       SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM      *BLANKS       SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM      *BLANKS       SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM      *BLANKS       SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM      *BLANKS       SVALK0           20
     C                   PARM                    SVAL10          200
      *                                                                                       CCG024
     C     RTNCDE        IFNE      *BLANKS
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
      *                                                                                       CCG024
     C                   MOVEL     'SDSVALR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     21            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG024
     C                   ENDIF
      *                                                                                       CCG024
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     5             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *
      * Cpysrc Templates Initialise Program C-spec
      *
     C/COPY WNCPYSRC,CG5270DCPG
     C/EJECT
      *
      * PSSR Processing
      *
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
      *
      * File and Program Error Processing
      *
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C/EJECT
     O@UDCLL2   E            UDCLL2
     O                       DLMSID
     O                       DLATIM
     O*@CSCHL0** E            CSCHL0                                                        MD054955
     O**********             CPBSNB                                                         MD054955
     O@CORRL0   E            CORRL0
     O                       CDBSNB
      *
      * Cpysrc Templates Initialise Program O-spec
      *
     O/COPY WNCPYSRC,CG5270DOPG
**  CPY@
(c) Finastra International Limited 2001
