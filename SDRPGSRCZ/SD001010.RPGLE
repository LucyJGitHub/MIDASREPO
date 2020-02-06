     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Initialize Year in DST File')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001010 -  Midas SD Initialize Year in DST File             *
      *                                                               *
      *  Function:  This program updates the DST File with the        *
      *             year coming from SDBANKPD                         *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG20220A          Date 25Jun08               *
      *                 BUG19113 *CREATE   Date 06Jun08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG20220A- Duplicate key error encountered in initialisation *
      *  BUG19113 - CSW208 Initialization pgm - SD001003              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Time Zone Update File
     FSDDSTCL0  UF   E           K DISK    INFSR(*PSSR)
 
     ** Midas SD DST Retriev File                                                          BUG20220A
     FSDDSTCL1  IF   E           K DISK    INFSR(*PSSR) RENAME(SDDSTCD0:DSTREC)            BUG20220A
     F                                                  PREFIX(L:0)                        BUG20220A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
     D ZDayNo          S              5P 0
     D cDSUSER         S                   Like(DSUSER)                                    BUG20220A
 
      *
      ** Parameter for 'AOBANKR0'
     D @Rtcd           S              7A
     D @Optn           S              7A
     D @Sard           S              6A
      *
     D CurYear         S              4A
      *
      ** Parameter for ZDATE9
     D ZYearNo         DS
     D  MDATYr                 1      4  0
     D  MDATMn                 5      6  0
     D  MDATDy                 7      8  0
     D PRetCode        S              1  0
      *
     D WRun            S              1A
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
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     DSTKey        KLIST                                                             BUG20220A
     C                   KFLD                    DSDSCD                                    BUG20220A
     C                   KFLD                    DSYEAR                                    BUG20220A
      *                                                                                    BUG20220A
     C     *LOVAL        SETLL     SDDSTCL0
     C                   READ      SDDSTCL0
     C                   DOW       NOT %EOF(SDDSTCL0)
     C                   IF        NOT(%EOF(SDDSTCL0))
     C                   MOVE      CurYear       DSYEAR
     C                   EVAL      cDSUSER = DSUSER                                        BUG20220A
     C     DSTKey        CHAIN     DSTREC                                                  BUG20220A
     C                   IF        NOT(%FOUND(SDDSTCL1)) And DSUSER = *Blanks              BUG20220A
     C                   UPDATE    SDDSTCD0
     C                   ENDIF                                                             BUG20220A
     C                   READ      SDDSTCL0
     C                   ENDIF
     C                   ENDDO
      *
      *
     C                   EVAL      *INLR = *ON                                             BUG20220A
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
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
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      *
      ** Call The Access Object - AOBANKR0
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSfdy
      *
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey  = @OPTN
     C                   EVAL      DBase  = 002
     C                   EXSR      *Pssr
     C                   ENDIF
      *
     C                   EVAL      ZDayNo = BJRDNB
     C                   EXSR      SRZDate9
     C                   Move      MDATYr        CurYear
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate9 - Convert day number to YYYYMMDD                    *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate9      BEGSR
      *
     C                   CALLB     'ZDATE9'
     C                   PARM                    ZDayNo
     C                   PARM      *ZERO         ZYearNo
     C                   PARM                    PRetCode
     C
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
