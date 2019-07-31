     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Invalid repo Deals delete')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMREPOIDL - INVALID REPO DELETE                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 CSC011             Date 14Mar02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
     FMMIRPLDL2 UF A E           K DISK
     FMMIRPDDL0 UF A E           K DISK
     FMMIRPTRL0 UF A E           K DISK
                                                                                              CSC011
      ** API Invalid log file by Type/FO Id/Time                                              CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)                                       CSC011
     F
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
      ** External DS for SAR details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D SCA_LCD       E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
     D @TMESTPSEL      S             26Z
     D @AFRT           S             20A
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D WMSGTYPE        S              8A                                                      CSC011
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
     C/COPY WNCPYSRC,MMREPOIC01
 
     C     LDKEY         KLIST
     C                   KFLD                    @AFRT
     C                   KFLD                    @TMESTPSEL
 
     C* Delete the Loans/Deposit for the deal (there SHOULD only be one but loop in case)
     C     LDKEY         CHAIN     MMIRPLDD0                          99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    MMIRPLDD0
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      WMSGTYPE  = 'MMRPLD'                                       CSC011
                                                                                              CSC011
     C     RPKY1         KLIST                                                                CSC011
     C                   KFLD                    WMSGTYPE                                     CSC011
     C                   KFLD                    @AFRT                                        CSC011
     C                   KFLD                    DDTMESTMP                                    CSC011
                                                                                              CSC011
     C     RPKY1         CHAIN     APILOGL0                           96                      CSC011
     C     *IN96         DOWEQ     *OFF                                                       CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C     RPKY1         READE     APILOGL0                               96                  CSC011
     C                   ENDDO                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     LDKEY         READE     MMIRPLDD0                              99
     C                   ENDDO
     C*
     C* Delete all Depot Movements for the deal
     C     @AFRT         CHAIN     MMIRPDD0                           98
     C     *IN98         DOWEQ     *OFF
     C                   DELETE    MMIRPDD0
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      WMSGTYPE  = 'MMRPDM'                                       CSC011
                                                                                              CSC011
     C     RPKY2         KLIST                                                                CSC011
     C                   KFLD                    WMSGTYPE                                     CSC011
     C                   KFLD                    @AFRT                                        CSC011
                                                                                              CSC011
     C     RPKY2         CHAIN     APILOGL0                           96                      CSC011
     C     *IN96         DOWEQ     *OFF                                                       CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C     RPKY2         READE     APILOGL0                               96                  CSC011
     C                   ENDDO                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     @AFRT         READE     MMIRPDD0                               98
     C                   ENDDO
      *
     C* Delete the Trailer for the deal (there SHOULD only be one but loop in case)
     C     @AFRT         CHAIN     MMIRPTRD0                          97
     C     *IN97         DOWEQ     *OFF
     C                   DELETE    MMIRPTRD0
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      WMSGTYPE  = 'MMRPTR'                                       CSC011
                                                                                              CSC011
     C     RPKY3         KLIST                                                                CSC011
     C                   KFLD                    WMSGTYPE                                     CSC011
     C                   KFLD                    @AFRT                                        CSC011
                                                                                              CSC011
     C     RPKY3         CHAIN     APILOGL0                             96                    CSC011
     C     *IN96         DOWEQ     *OFF                                                       CSC011
     C                   DELETE    APILOGL0                                                   CSC011
     C     RPKY3         READE     APILOGL0                               96                  CSC011
     C                   ENDDO                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C     @AFRT         READE     MMIRPTRD0                              97
     C                   ENDDO
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    @AFRT
     C                   PARM                    @TMESTPSEL
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMREPOIDL'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE                                                                 CSC011
**  CPY@
(c) Finastra International Limited 2001
