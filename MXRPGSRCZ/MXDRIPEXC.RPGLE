     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Drip-Feed Extract Controller')                *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  MXDRIPEXC - Drip-Feed Extract Controller                     *
      *                                                               *
      *  Function:  This module calls the                             *
      *             drip-feed extract                                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CTI006             Date 31Mar14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                         *CREATE    Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI006 - Trade Finance BF Midas 2.2 Interface                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXEXFDL2  IF   E           K DISK    INFSR(*PSSR)
     FMXCOMFPD  IF   E           K DISK    INFSR(*PSSR)
     FMXCOMDPD  IF   E           K DISK    INFSR(*PSSR)                                       CTI006
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Maximum number of formats
     D MaxNoFmts       C                   CONST(200)
      * FILE ARRAY
     D #_FILE          S             10    DIM(MaxNoFmts)
 
 
     D #_RCV1          S              1    DIM(30) CTDATA PERRCD(30)
     D #_RCV2          S              1    DIM(120) CTDATA PERRCD(60)
     D RCVJRNE         S              1    DIM(2500)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    JRNSEQA          10
 
      * Move in files
 
     C                   MOVEA     #_RCV1        RCVJRNE(1)
     C                   MOVEA     #_FILE        RCVJRNE(25)
 
      * Find end of files
 
     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *
     C                   MOVEA     #_RCV2        RCVJRNE(@T)
 
      * Find journal sequence number
 
     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *
     C                   MOVEA     JRNSEQA       RCVJRNE(@T)
 
      * Find end of command
 
     C                   Z-ADD     1             @T
     C     '!'           LOOKUP    RCVJRNE(@T)                            99    *
     C                   MOVE      ' '           RCVJRNE(@T)
 
      * Execute RCVJRNE
 
     C                   Z-ADD     @T            #MesLen          15 5
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    RCVJRNE
     C                   PARM                    #MesLen
 
 
      * 'Normal' return
 
     C                   RETURN
 
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Load all COMPOSITE formats for drip-feed
      *********************************************************************
     C     LOAD_COM      BEGSR
 
      * Read all composite formats for activity extracts
 
     C     *LOVAL        SETLL     MXCOMFP0
     C                   READ      MXCOMFP0                               99    *
     C     *IN99         DOWEQ     '0'
                                                                                              CTI006
      * Access composite message                                                              CTI006
                                                                                              CTI006
     C     MXCOMDK       CHAIN     MXCOMDP0                           99                      CTI006
 
      **Store*each*'driver'*file*within*an*activity*extract****************                   CTI006
      * Store each 'driver' file within an extract                                            CTI006
      * that is to be dripfed
 
     C*****CFEXTT        IFEQ      'A'                                                        CTI006
     C*****CFLFMT        ANDEQ     '*DRIVER   '                                               CTI006
     C     CFLFMT        IFEQ      '*DRIVER   '                                               CTI006
     C     *IN99         ANDEQ     '0'                                                        CTI006
     C     CDMSGQ        ANDNE     *BLANK                                                     CTI006
     C     CDENAB        ANDNE     'N'                                                        CTI006
 
     C     CFFMT         CHAIN     MXEXFDP0                           99        *
     C     *IN99         IFEQ      '0'
     C     EXDRIP        ANDEQ     'Y'
     C     EXFDCR        ANDEQ     'Y'
     C                   Z-ADD     1             @T                5 0
     C     EXFILE        LOOKUP    #_FILE(@T)                             99    *
 
     C     *in99         ifeq      '0'
     C                   Z-ADD     1             @T
     C     *BLANK        LOOKUP    #_FILE(@T)                             99    *
     C                   MOVEL     EXFILE        #_FILE(@T)
     C                   endif
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      MXCOMFP0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Load all SINGLE FILE formats for drip-feed
      *********************************************************************
     C     LOAD_FIL      BEGSR
 
      * Read all export formats
 
     C     *LOVAL        SETLL     MXEXFDP0
     C                   READ      MXEXFDP0                               99    *
     C     *IN99         DOWEQ     '0'
 
      * Store each format within the export formats
      * that is to be dripfed and if an MQ/SERIES QUEUE is specified
 
     C     EXDRIP        IFEQ      'Y'
     C     EXFDCR        ANDEQ     'Y'
     C     EXMSGQ        ANDNE     *BLANK
     C     EXENAB        ANDNE     'N'                                                        CTI006
     C                   Z-ADD     1             @T
     C     EXFILE        LOOKUP    #_FILE(@T)                             99    *
 
     C     *in99         ifeq      '0'
     C                   Z-ADD     1             @T
     C     *BLANK        LOOKUP    #_FILE(@T)                             99    *
     C                   MOVEL     EXFILE        #_FILE(@T)
     C                   endif
     C                   ENDIF
 
     C                   READ      MXEXFDP0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     'SDBANKPD'    #_FILE(1)
 
 
      * Load all COMPOSITE formats for drip-feed
 
     C                   EXSR      LOAD_COM
 
      * Load all SINGLE FILE formats for drip-feed
 
     C                   EXSR      LOAD_FIL
 
     C                   Z-ADD     1             @T
     C     *BLANK        LOOKUP    #_FILE(@T)                             99    *
     C                   MOVEL     '!'           #_FILE(@T)
 
     C     MXCOMDK       KLIST                                                                CTI006
     C                   KFLD                    CFCOMI                                       CTI006
     C                   KFLD                    CFEXTT                                       CTI006
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** #_RCV1
RCVJRNE JRN(ICJRN) FILE(
** #_RCV2
) EXITPGM(MXDRIPEXT) FROMENT(!000000000) JRNCDE((R) (U))
ENTTYP(PT UB UP XJ XE) DELAY(02) !
