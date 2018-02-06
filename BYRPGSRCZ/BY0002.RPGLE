     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas BoE Update ISO Codes and Country Codes')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY0002 - Update MidasPlus with the BOE codes                 *
      *                                                               *
      *  Function:  This program checks whether the BOE ISO code      *
      *             is existing in GPICTRYPD and creates record       *
      *             if not found. Also creates record in SDCTRYPD.    *
      *                                                               *
      *  Called By: BY0001                                            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. BUG7336 *CREATE    Date 07Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
/*    *  BUG7336- BYCNTYPP not migrated to MidasPlus BOE              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    30         No Details                                      *
      *    31         Rec Found Indicator                             *
      *    89         Rec Found Indicator                             *
      *    90         Rec Found Indicator                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
     FGPICTRYL0 UF A E           K DISK
      ** Country Codes Details
 
     FSDCTRYL2  UF A E           K DISK
      ** Country Codes Details
 
     FBYCNTYV1  IF   E           K DISK
      ** Bank of England Country Codes By ISO Code
 
     FQSYSPRT   O    F  132        PRINTER OFLIND(*INOF)
      ** Audit Report
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** First DS for access programs, short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WValid          S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D WRUN            S              1A
     D WCount          S              5  0
 
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
 
      ** Process BOE ISO that are not existing in GPICTRYPD
 
     C                   EXSR      SRNExist
 
      ** Termination Processing
 
     C                   EXSR      SRTerminate
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNExist - ISO Code not existing processing                   *
      *                                                               *
      *****************************************************************
 
     C     SRNExist      BEGSR
 
      ** Read through BOE codes file
 
     C     *LOVAL        SETLL     BYCNTYV1
     C                   READ      BYCNTYV1                               89
 
     C                   EVAL      WCount = 0
 
     C                   DOW       *IN89 = *OFF
 
      **  Validate ISO code
 
     C                   EXSR      SRValNExist
 
      **  Report details if to be listed/updated
 
     C                   IF        WValid = 'N'
     C                   EXSR      SRReport
     C                   ENDIF
 
     C                   READ      BYCNTYV1                               89
     C                   ENDDO
 
      ** No Details
 
     C                   EVAL      *IN30 = *OFF
     C                   IF        WCount = 0
     C                   EVAL      *IN30 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTerminate - Termination Processing                          *
      *                                                               *
      *****************************************************************
 
     C     SRTerminate   BEGSR
 
     C                   EXCEPT    END
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValNExist - Validate ISO Code                               *
      *                                                               *
      *****************************************************************
 
     C     SRValNExist   BEGSR
 
      ** Check if all Bank of England ISO code exist in MidasPlus
 
     C                   EVAL      WValid = 'Y'
     C     LBISOC        CHAIN     GPICTRYL0                          90
 
      ** List record if not found
 
     C                   IF        *IN90 = *ON
     C                   MOVE      'N'           WValid
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReport - Report Details of Changes and Update               *
      *                                                               *
      *****************************************************************
 
     C     SRReport      BEGSR
 
      ** Output Heading if Overflow
 
     C                   IF        *INOF = *ON
     C                   EVAL      *INOF = *OFF
     C                   EXCEPT    HDR
     C                   ENDIF
 
      ** Update the files
 
     C                   EXSR      SRUpdate
 
      ** Output Detail
     C                   EXCEPT    DTL
 
     C                   EVAL      WCount = WCount + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update File                                        *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** Write new ISO record in GPICTRYPD
 
     C                   EVAL      CNCNCD = LBISOC
     C                   EVAL      CNCNNM = LBCNNM
     C                   WRITE     GPICTRYD0
 
      ** Write new Country Code record in SDCTRYPD
 
     C     LBISOC        CHAIN     SDCTRYL2                           31
     C                   IF        *IN31 = *ON
     C                   EVAL      A4CNCD = LBISOC
     C                   EVAL      A4RGCD = *BLANK
     C                   EVAL      A4LCD = BJRDNB
     C                   EVAL      A4TYLC = 'I'
     C                   EVAL      A4CNNM = LBCNNM
     C                   EVAL      A4ISOC = LBISOC
     C                   EVAL      A4MLOC = *BLANK
     C                   EVAL      A4BBAN = 0
     C                   EVAL      A4BBRL = 0
     C                   EVAL      A4CTAY = *BLANK
     C                   EVAL      A4CTZP = *BLANK
     C                   EVAL      A4CTWC = 0
     C                   EVAL      A4ZONE = *BLANK
     C                   WRITE     SDCTRYD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Output Heading
 
     C                   EXCEPT    HDR
 
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
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
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
     OQSYSPRT   E            HDR              03
     O                                           24 'REFERENCE BY0002'
     O                       BJURPT              90
     O                                          104 'DATE'
     O                       BJMRDT             112
     O                                          122 'PAGE'
     O                       PAGE          Z    127
 
     O          E            HDR              05
     O                                           95 'BOE Codes Not Existing +
     O                                              from Global ISO Codes +
     O                                              file - UPDATE'
     O          E            HDR            1 06
     O                                           61 '------------------------'
     O                                           82 '---------------------'
     O                                           95 '-------------'
     O          E            HDR              08
     O                                           37 'BOE ISO'
     O          E            HDR              09
     O                                           37 'Code'
     O                                           52 'Description'
     O                                           89 'Copied to MPlus?'
     O                                          100 'MPlus Code'
     O          E            HDR              10
     O                                           37 '----'
     O                                           52 '-----------'
     O                                           89 '----------------'
     O                                          100 '----------'
 
     O          E            DTL         1  1
     O              N31                         125 '** EXISTING IN SDCTRYPD **'
     O                       LBISOC              36
     O                       LBCNNM              69
     O                                           81 'Y'
     O                       LBISOC              96
 
     O          E            END         2
     O               30                          79 '*** NO DETAILS TO REPORT +
     O                                              ***'
     O          E            END         2
     O                                           75 '*** END OF REPORT ***'
