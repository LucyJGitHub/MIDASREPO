     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AS Historic Net Value with delay')               *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000026 - DL Derivative Historic Net Value                  *
      *                                                               *
      *  Called By: ASC00019 - Historic Market Data Collection (CLP)  *
      *                                                               *
      *  Function:  This program keeps historic deal net present      *
      *             values.  The historic values will be used when    *
      *             a delayed price was defined for a transaction     *
      *             using dollar offset method.                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008  *CREATE    Date 11May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS008 - Delayed Hedge Assessment                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR     - Initialization Processing                        *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FASHTRNJ1  IF   E           K DISK    INFSR(*PSSR)
 
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)
 
     FIRNPVBL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRNPVAD0:IRNPVBD0)
 
     FRXNPVAL0  IF   E           K DISK    INFSR(*PSSR)
 
     FRXNPVBL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RXNPVAD0:RXNPVBD0)
 
     FFRNPVAL0  IF   E           K DISK    INFSR(*PSSR)
 
     FFRNPVLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FRNPVAD0:FRNPVBD0)
 
     FDLNPVLL3  IF   E           K DISK    INFSR(*PSSR)
 
     FIRSNHVPD  UF A E             DISK
     FRXSNHVPD  UF A E             DISK
     FFRANHVPD  UF A E             DISK
     FDLNHVLPD  UF A E             DISK
 
     ******************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Dealing ICD
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Fields used to define Key List for Midas DL Forward Commitment File
     D KDLnpvm         S              1A
     D KDLdlno         S              6P 0
 
     D PRetCode        S              7A
     D POption         S              7A
 
     D WRun            S              1
                                                                                              CLE148
     IDLNPVLD0                                                                                CLE148
     I              FSDLNO                      DLDLNO                                        CLE148
                                                                                              CLE148
     IDLNHVLD0                                                                                CLE148
     I              FSDLNO                      DLDLNO                                        CLE148
                                                                                              CLE148
     ******************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   READ      ASHTRNJ1                               01
 
     C     *IN01         DOWEQ     '0'
 
     C                   EVAL      *IN04 = '0'
     C                   EVAL      *IN05 = '0'
     C                   EVAL      *IN08 = '0'
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
 
     C                   IF        FSEFFD = BJRDNB
     C                   EVAL      IREFFD = FSEFFD
 
     C*****FSDLNO        CHAIN     IRNPVAL0                           02                      CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                           02                      CLE148
 
     C                   IF        *IN02 = '0'
     C                   EVAL      IRABIN = 'A'
     C                   WRITE     IRSNHVD0
 
     C*****FSDLNO        CHAIN     IRNPVBL0                           03                      CLE148
     C     FSDLNO2       CHAIN     IRNPVBL0                           03                      CLE148
     C                   IF        *IN03 = '0'
     C                   EVAL      IRABIN = 'B'
     C                   WRITE     IRSNHVD0
     C                   ENDIF
     C                   ENDIF
     C
     C*****FSDLNO        SETLL     RXNPVAL0                                                   CLE148
     C*****FSDLNO        READE     RXNPVAL0                               04                  CLE148
     C     FSDLNO2       SETLL     RXNPVAL0                                                   CLE148
     C     FSDLNO2       READE     RXNPVAL0                               04                  CLE148
 
     C                   DOW       *IN04 = '0'
     C                   EVAL      IRABIN = 'A'
     C                   WRITE     RXSNHVD0
     C*****FSDLNO        READE     RXNPVAL0                               04                  CLE148
     C     FSDLNO2       READE     RXNPVAL0                               04                  CLE148
     C                   ENDDO
 
     C*****FSDLNO        SETLL     RXNPVBL0                                                   CLE148
     C*****FSDLNO        READE     RXNPVBL0                               05                  CLE148
     C     FSDLNO2       SETLL     RXNPVBL0                                                   CLE148
     C     FSDLNO2       READE     RXNPVBL0                               05                  CLE148
 
     C                   DOW       *IN05 = '0'
     C                   EVAL      IRABIN = 'B'
     C                   WRITE     RXSNHVD0
     C*****FSDLNO        READE     RXNPVBL0                               05                  CLE148
     C     FSDLNO2       READE     RXNPVBL0                               05                  CLE148
     C                   ENDDO
 
     C*****FSDLNO        CHAIN     FRNPVAL0                           06                      CLE148
     C     FSDLNO2       CHAIN     FRNPVAL0                           06                      CLE148
 
     C                   IF        *IN06 = '0'
     C                   EVAL      IRABIN = 'A'
     C                   WRITE     FRANHVD0
 
     C*****FSDLNO        CHAIN     FRNPVLL0                           07                      CLE148
     C     FSDLNO2       CHAIN     FRNPVLL0                           07                      CLE148
     C                   IF        *IN07 = '0'
     C                   EVAL      IRABIN = 'B'
     C                   WRITE     FRANHVD0
     C                   ENDIF
     C                   ENDIF
 
     C**********         EVAL      KDLdlno = FSDLNO                                           CLE148
     C                   EVAL      KDLdlno = FSDLNO2                                          CLE148
     C     KDLNPV        SETLL     DLNPVLL3                               08
     C     KDLNPV        READE     DLNPVLL3                               08
     C                   DOW       *IN08 = '0'
     C                   WRITE     DLNHVLD0
     C     KDLNPV        READE     DLNPVLL3                               08
     C                   ENDDO
      *
      *
     C                   ENDIF
 
     C                   READ      ASHTRNJ1                               01
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
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
     C     *INZSR        BEGSR
 
     C     KDLNPV        KLIST
     C                   KFLD                    KDLnpvm
     C                   KFLD                    KDLdlno
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access the Dealing ICD file
 
     C                   CALL      'AODEALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDDEAL        PARM      SDDEAL        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDDEALPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBASE  =  002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCode = *BLANKS
 
      ** If Reval NPV method is blank
 
     C                   IF        BNNPVM = *BLANKS
     C                   EVAL      KDLnpvm = 'N'
     C                   ELSE
     C                   EVAL      KDLnpvm = BNNPVM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
