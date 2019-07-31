     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD History after retention period')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDMDFHDL - Delete History after Retention Period             *
      *                                                               *
      *  Function:  This program physically deletes all History       *
      *             file records older than the specified history     *
      *             retention period.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 01Jun01               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD006 - Market Data Feed                                    *
      *                                                               *
      *****************************************************************
 
     F/COPY WNCPYSRC,SDMDFHDFPG
 
     FSDMDFHPD  UF   E             DISK    USROPN
      *
     FSDMDFCL0  IF   E           K DISK
      *
     F/COPY WNCPYSRC,SDMDFHDF01
      *
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
     D*
     D/COPY WNCPYSRC,SDMDFHDEPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D/COPY WNCPYSRC,SDMDFHDIPG
      /EJECT
      * Data structures:
     D*
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
     D*
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Currency details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
      *
     D/COPY WNCPYSRC,SDMDFHDI01
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Calculate the History Retention date
     C                   EXSR      SCLHRD
      *
      * Main Processing
     C                   EXSR      MAIN
      *
     C/COPY WNCPYSRC,SDMDFHDCPG
      *----------------------------------------------------------------
      * Exit program
      * Terminate program
     C                   SETON                                        LR
     C                   EXSR      EXIT
      *================================================================
      /EJECT
     C     MAIN          BEGSR
      *================================================================
      * Remove MDF History File records older than History Retention
      *================================================================
      *
     C                   READ      SDMDFHPD                               90
     C*
     C     *IN90         DOWEQ     '0'
     C*
     C     RHPRCD        IFLT      WUHRDT
     C                   DELETE    SDMDFHD0                             91
     C                   ENDIF
     C*
     C                   READ      SDMDFHPD                               90
     C*
     C                   ENDDO
      *================================================================
     C                   ENDSR
      /EJECT
     C     SCLHRD        BEGSR
      *================================================================
      * Calculate History Retention Date
      *================================================================
      *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVEL     MRDT          WUMRDT
     C                   MOVEL     RDNB          WURDNB                         RUNDAY NO.
      *
     C*Retrieve History Retention Period
      * Define keylist
     C     KMDFC         KLIST
     C                   KFLD                    MDTRGI
      *
      * MOVELfields to key list
     C                   MOVEL     *BLANK        MDTRGI
      *
     C     KMDFC         SETLL     SDMDFCD0
     C                   READ      SDMDFCL0                               90
     C*
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'SDMDFCL0'    DBFILE                                        *****
     C                   Z-ADD     001           DBASE                                         * DBE
     C                   MOVEL     *BLANK        DBKEY                                         *****
     C                   MOVEL     'SDMDFHDL'    DBPGM
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   ENDIF
     C*
     C                   MOVEL     MDHRTP        WUHRTP
     C*
     C*Retrieve Local Currency
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE                                        *****
     C                   Z-ADD     002           DBASE                                         * DBE
     C                   MOVEL     POPTN         DBKEY                                         *****
     C                   MOVEL     'SDMDFHDL'    DBPGM
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   END
      *
     C                   MOVEL     BJLCCY        WULCCY
      *
     C*Attempt to Retrieve Location Code for Local Currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*KEY   '     WOPTN             7
     C                   PARM      WULCCY        WCYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     WRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     3             DBASE                          * DBERR 03 *
     C                   MOVEL     WULCCY        DBKEY                          ************
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   ENDIF
      *
     C     A6DLOC        IFEQ      *BLANKS
      *No Default Location Code for currency found
     C                   MOVEL     *ON           *IN50
     C*
     C                   ELSE
     C                   MOVEL     A6DLOC        WUDLOC
      *Retrieve rundate for History Retention date using default location code in SDCURRPD
     C                   Z-ADD     0             WUDNBR            5 0
     C*
     C                   CALLB     'RVFBDT'
     C                   PARM      WURDNB        ZDAYNO            5 0
     C                   PARM      WUHRTP        ZNRDYS            2 0
     C     ZDYNBR        PARM      WUDNBR        ZDYNBR            5 0
     C                   PARM      WULCCY        ZCCY              3
     C                   PARM      WUDLOC        ZLOC              3
     C*
     C                   MOVEL     ZDYNBR        WUHRD1            5 0
     C*
     C                   ENDIF
     C*
      *Retrieve rundate for 2 working days ago using location code of '***' in case holiday
      *details not found for local currency default location (upon which module merely assumes no
     C*holidays exist)
     C*
     C                   MOVEL     '***'         WUDLOC
     C                   MOVEL     *BLANKS       WUDNBR
     C                   MOVEL     *BLANKS       ZDYNBR
     C*
     C                   CALLB     'RVFBDT'
     C                   PARM      WURDNB        ZDAYNO            5 0
     C                   PARM      WUHRTP        ZNRDYS            2 0
     C     ZDYNBR        PARM      WUDNBR        ZDYNBR            5 0
     C                   PARM      WULCCY        ZCCY              3
     C                   PARM      WUDLOC        ZLOC              3
     C*
     C                   MOVEL     ZDYNBR        WUHRD2            5 0
     C*
     C*If the Default Location was never found use the History Retention Date as calculated
     C*using '***' location code
     C     *IN50         IFEQ      *ON
     C                   Z-ADD     WUHRD2        WUHRDT
     C                   ELSE
     C*Otherwise use the earlier of the two (in case Default Location Code was not found in Holiday
     C*File and so no holidays were assumed)
     C     WUHRD1        IFLT      WUHRD2
     C                   Z-ADD     WUHRD1        WUHRDT
     C                   ELSE
     C                   Z-ADD     WUHRD2        WUHRDT
     C                   ENDIF
     C*
     C                   END
      *================================================================
     C                   ENDSR
      /EJECT
     C     EXIT          BEGSR
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
     CSR                 ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
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
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * History Retention Period
     C                   MOVEL     *BLANK        WUHRTP            3 0
      * Define work field History Retention Date
     C                   Z-ADD     *ZERO         WUHRDT            5 0
      * Define work field Local Currency Field
     C                   MOVEL     *BLANK        WULCCY            3
      * Define work field Local Currency Default Location Code
     C                   MOVEL     *BLANK        WUDLOC            3
     C/COPY WNCPYSRC,SDMDFHDC01
      * Open files
     C                   OPEN      SDMDFHPD
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
