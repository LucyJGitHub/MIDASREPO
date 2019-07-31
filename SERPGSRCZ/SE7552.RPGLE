     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Corporate actions family tree report')
/*OVR *  OVRDBF FILE(SECORFLA1) TOFILE(SECORFLA) SHARE(*NO)           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7552 - SE Corporate Actions Family Tree Report             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE020   *CREATE   Date 21Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE020 - Corporate Actions Domino Effect Processing          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      **   SE Corporate Actions Without Any Child Action
     FSECORFLB  IF   E           K DISK
      *
      **   SE Corporate Actions by Parent Action Reference
     FSECORFLA  IF   E           K DISK
     F                                     PREFIX(B)
      *
      **   SE Corporate Actions by Parent Action Reference
     FSECORFLA1 IF   E           K DISK
     F                                     RENAME(@SECOLA:@SECOLA1)
     F                                     PREFIX(A)
      *
      **   SE Corporate Action Type
     FSECOATL0  IF   E           K DISK
      *
      **   SE Corporate Action Family Tree Report - Audit
     FSE7552AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      *
      **   SE Corporate Action Family Tree Report
     FSE7552P1  O    E             PRINTER INFDS(SPOOL1)
     D*****************************************************************
      /EJECT
     D*****************************************************************
      *                                                               *
      * ID F  C  H  L    Function of indicators                       *
      * ---------------------------------------                       *
      *                                                               *
      *   LR :    Last record                                         *
      *   U7/U8 : Database error                                      *
      *                                                               *
      *   01 : File Indicator on SECORFLB                             *
      *   02 : File Indicator on SECORFL1A                            *
      *   03 : File Indicator on SECORFLA                             *
      *   90 : File Indicator on SECOATL0                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                   Index to subroutines                        *
      *  Main Routine                                                 *
      *  SRINRP  -  Initialise Report Fields                          *
      *  SRREPT  -  Output Details to Report                          *
      *  SRDETL  -  Format and Write a Detail Record on the Report    *
      *  SRAUDT  -  Output Audit Report and End program               *
      *  SRTERM  -  Output End of Report                              *
      *                                                               *
      *  *PSSR   -  "Standard" Database error processing              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
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
      ********************************************************************
      /EJECT
      ********************************************************************
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Data structure for branch details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Data structure for Switchable feature details
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  Data structure for securities trading details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access objects
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Idx             S              2S 0
 
      * Recursive Procedure
     D TreeProc        PR
     D IPName                         6A
     D Idx                            2S 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      **    P R O G R A M   S T A R T
      *****************************************************************
      *
      ** Initial Processing
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD             7
     C                   PARM                    PAUFL             1
     C                   PARM                    PRSEQ             5
     C                   PARM                    PLEVL             1
     C                   PARM                    PENTY             3
      *
     C     *HIVAL        SETLL     SECORFLB
     C                   READ      SECORFLB                               01
      *
     C                   IF        *IN01
     C                   EVAL      WNODTL = 'Y'
     C                   EXSR      SRAUDT
     C                   ELSE
      *
      ** Write Header Record
      *
     C                   WRITE     HEADP1
      *
     C                   DOW       NOT *IN01
     C                   EVAL      R_CORF = MACORF
     C     R_CORF        SETLL     SECORFLA1
     C     R_CORF        READE     @SECOLA1                             0202
      *
     C                   IF        NOT *IN02
     C                   EVAL      R_LEVL = '+'
     C                   ELSE
     C                   EVAL      R_LEVL = ' '
     C                   ENDIF
      *
     C                   EXSR      SRREPT
      *
     C                   IF        NOT *IN02
     C                   CALLP     TreeProc(R_CORF:Idx)
     C                   ENDIF
      *
     C                   EVAL      Idx = 0
     C                   READ      SECORFLB                               01
     C                   ENDDO
      *
     C                   ENDIF
     C                   EXSR      SRTERM
     C                   EVAL      PRTCD = *BLANKS
     C                   RETURN
      *
      *****************************************************************
      **    P R O G R A M     E N D
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINRP : Initialise Report Fields                             *
      *****************************************************************
      *
     C     SRINRP        BEGSR
     C                   EVAL      R_CORF = *BLANKS
     C                   EVAL      R_LEVL = *BLANKS
     C                   EVAL      R_SHNM = *BLANKS
     C                   EVAL      R_ACCD = *BLANKS
     C                   EVAL      R_TPDS = *BLANKS
     C                   EVAL      R_DTAN = *BLANKS
     C                   EVAL      R_EXDT = *BLANKS
     C                   EVAL      R_ALEF = *BLANKS
     C                   EVAL      R_NOOP = *BLANKS
     C                   EVAL      R_STTS = *BLANKS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRREPT : Output Details to Report                             *
      *****************************************************************
      *
     C     SRREPT        BEGSR
      *
     C                   EVAL      R_SHNM = MASESN
     C                   EVAL      R_ACCD = MACOAT
      *
     C     MACOAT        CHAIN     SECOATL0                           90
     C                   IF        *IN90
     C                   EVAL      DBFILE = 'SECOATL0'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = MACOAT
     C                   EXSR      SRAUDT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      R_TPDS = MMDESC
     C                   ENDIF
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      MACOAN        ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      R_DTAN = ZADATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      MACOEX        ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      R_EXDT = ZADATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      MAALEF        ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      R_ALEF = ZADATE
      *
     C                   MOVE      MANBOP        R_NOOP
     C                   EVAL      R_STTS = MASTAT
     C                   EXSR      SRDETL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDETL : Format and Write a Detail Record on the Report       *
      *****************************************************************
      *
     C     SRDETL        BEGSR
      *
      ** Print Header if no more sufficient lines exist
      *
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Print Detail line
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAUDT : Output Audit Report and End program                  *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
     C                   OPEN      SE7552AU
     C                   Z-ADD     SFNUMU        SPLNO
     C                   EVAL      SFILP = SFILEU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ              5
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
 
     C                   IF        ZERR = 'Y'
     C                   EVAL      DBKEY = 'SE7552AU'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Output Report Header
      *
     C                   WRITE     HEADAU
      *
      ** Database Error
      *
     C                   IF        DBFILE <> *BLANKS
     C                   WRITE     DBERROR
     C                   ENDIF
      *
      ** No Details to Report
      *
     C                   IF        WNODTL = 'Y'
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   CLOSE     SE7552AU
      *
     C                   IF        WNODTL = 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * SRTERM : Output End of Report                                 *
      *****************************************************************
      *
     C     SRTERM        BEGSR
      *
      ** Print Header if no more sufficient lines exist
      *
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Print End of Report Line
      *
     C                   WRITE     TRAILP1
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Initial Processing                                   *
      *                                                               *
      * Called by: During Program Activation                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
     C                   EVAL      DBPGM = 'SE7552'
     C                   EVAL      DBFILE = *BLANKS
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
t    C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      SRAUDT
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access to Securities Trading Data                                  OD
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** If Record is not found
      *
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBASE = 2                                    ************
     C                   EVAL      DBFILE = 'SDSTRDPD'                          * DBERR 02 *
     C                   EVAL      DBKEY = @OPTN                                ************
     C                   EXSR      SRAUDT
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     SFNUM1        SPLNO
     C                   EVAL      SFILP = SFILE1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ              5
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
 
     C                   IF        ZERR = 'Y'
     C                   EVAL      DBKEY = 'SE7552P1'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EXSR      SRAUDT
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Report Work fields.
      *
     C                   MOVE      'N'           WNODTL            1
      *
     C                   TIME                    TIME              6 0
     C                   EVAL      Idx = 0
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
     C                   EXSR      SRINRP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      *********************************************************************
      * Recursive Procedure
      *********************************************************************
     P TreeProc        B
 
     D TreeProc        PI
     D  IPName                        6A
     D  Idx                           2S 0
 
     D K_PREF          S                   LIKE(MAPREF)
     D K_CREF          S                   LIKE(MAPREF)
     C                   EVAL      Idx = Idx + 1
      *
      ** Read in the current level
      *
     C     IPName        SETLL     SECORFLA
     C     IPName        READE     @SECOLA                                03
      *
      ** Loop through the current level
      *
     C     *IN03         DOWEQ     *OFF
      *
      ** Save file pointer
      *
     C                   MOVE      BMAPREF       K_PREF
     C                   MOVE      BMACORF       K_CREF
     C                   MOVE      BMACORF       R_CORF
     C                   MOVE      Idx           R_LEVL
      *
     C                   EXSR      SRREPT
 
     C     R_CORF        SETLL     SECORFLA1
     C     R_CORF        READE     @SECOLA1                             0404
      *-- Recur
     C                   IF        *IN04 = '0'
     C                   CALLP     TreeProc(R_CORF:Idx)
     C                   EVAL      Idx = Idx - 1
     C                   ENDIF
      *
      ** Restore file pointer
      *
     C     K_SECA        KLIST
     C                   KFLD                    K_PREF
     C                   KFLD                    K_CREF
     C     K_SECA        SETGT     SECORFLA
      *
      ** Read next record in current level
      *
     C     K_PREF        READE     @SECOLA                                03
     C                   ENDDO
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRREPT : Output Details to Report                             *
      *****************************************************************
      *
     C     SRREPT        BEGSR
      *
     C                   EVAL      R_SHNM = BMASESN
     C                   EVAL      R_ACCD = BMACOAT
      *
     C     BMACOAT       CHAIN     SECOATL0                           90
     C     *IN90         IFEQ      *ON
     C                   EVAL      DBFILE = 'SECOATL0'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = BMACOAT
     C                   EXSR      SRAUDT
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      R_TPDS = MMDESC
     C                   ENDIF
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      BMACOAN       ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      R_DTAN = ZADATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      BMACOEX       ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      R_EXDT = ZADATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      BMAALEF       ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      R_ALEF = ZADATE
      *
     C                   MOVE      BMANBOP       R_NOOP
     C                   EVAL      R_STTS = BMASTAT
     C                   EXSR      SRDETL
      *
     C                   ENDSR
      *****************************************************************
      * SRDETL : Format and Write a Detail Record on the Report       *
      *****************************************************************
      *
     C     SRDETL        BEGSR
      *
      ** Print Header if no more sufficient lines exist
      *
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ** Print Detail line
      *
     C                   WRITE     DETAIL
      *
     C                   ENDSR
      *****************************************************************
      * SRAUDT : Output Audit Report and End program                  *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
     C                   OPEN      SE7552AU
     C                   Z-ADD     SFNUMU        SPLNO
     C                   EVAL      SFILP = SFILEU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    RSEQ              5
     C                   PARM      *BLANKS       RENT              3
     C                   PARM                    SFILP            10
     C                   PARM                    SPLNO             6 0
     C                   PARM      *BLANKS       ZERR              1
 
     C                   IF        ZERR = 'Y'
     C                   EVAL      DBKEY = 'SE7552AU'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'ZSFILE'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Output Report Header
      *
     C                   WRITE     HEADAU
      *
      ** Database Error
      *
     C                   IF        DBFILE <> *BLANKS
     C                   WRITE     DBERROR
     C                   ENDIF
      *
      ** No Details to Report
      *
     C                   IF        WNODTL = 'Y'
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   CLOSE     SE7552AU
      *
     C                   IF        WNODTL = 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
 
 
     P TreeProc        E
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
