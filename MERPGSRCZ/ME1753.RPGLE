     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME SWIFTRef Activate Directory entries')         *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1753 - Midas ME SWIFTRef Activate Directory entries        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CSW218             Date 19Mar18               *
      *  Prev Amend No. CFT051  *CREATE    Date 04Jun15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  CFT051 - SWIFTRef Directories 2014                           *
      *                                                               *
      *****************************************************************
      *
     FMEIASDL0  UF A E           K DISK
     F                                     RENAME(MEIASDD0:SDINACT)
      ** SWIFTRef Service Directory - Inactive
      *
     FMEBISDL0  UF A E           K DISK
     F                                     RENAME(MEBISDD0:SDACTIV)
      ** SWIFTRef Service Directory
      *
      *
     FMEIAB3L0  UF A E           K DISK
     F                                     RENAME(MEIAB3D0:B3INACT)
      ** SWIFTRef BANK DIRECTORY Plus - Inactive
      *
     FMEBIB3L0  UF A E           K DISK
     F                                     RENAME(MEBIB3D0:B3ACTIV)
      ** SWIFTRef BANK DIRECTORY Plus
      *
      *
     FMEIASIL0  UF A E           K DISK
     F                                     RENAME(MEIASID0:SIINACT)
      ** SWIFTRef SSI Plus  Inactive
      *
     FMESSIPL0  UF A E           K DISK
     F                                     RENAME(MESSIPD0:SIACTIV)
      ** SWIFTRef SSI Plus DIRECTORY
      *
      *
     FMEIAIBL0  UF A E           K DISK
     F                                     RENAME(MEIAIBD0:N3INACT)
      ** SWIFTRef IBAN Plus DIRECTORY - Inactive
      *
     FMEIBN3L0  UF A E           K DISK
     F                                     RENAME(MEIBN3D0:N3ACTIV)
      ** SWIFTRef IBAN Plus DIRECTORY
      *
      *
     FMEIASPL0  UF A E           K DISK
     F                                     RENAME(MEIASPD0:SPINACT)
      ** SWIFTRef SEPA Plus DIRECTORY  Inactive
      *
     FMESEPAL0  UF A E           K DISK
     F                                     RENAME(MESEPAD0:SPACTIV)
      ** SWIFTRef SEPA Plus DIRECTORY
      *
     FMEIBNSL0  IF   E           K DISK
      ** IBAN Plus Directory/Structure
      *
     FMEBICDL3  UF A E           K DISK
     F                                     Prefix(D_)
      ** BIC Directory
      *
     FMEBICPL0  UF A E           K DISK
     F                                     Prefix(P_)
      ** BIC Plus Directory
      *
     FMEBICBL0  UF A E           K DISK
     F                                     Prefix(B_)
      ** IBAN Plus Directorry
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *       71  Read Indicator for Downloaded files                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
     D LDA             DS           256
      ** Local data area for database error details
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
      *
     D IASDDS        E DS                  EXTNAME(MEIASDPD)
      ** Midas ME SWIFTRef Service Directory - Inactive
      *
     D BISDDS        E DS                  EXTNAME(MEBISDPD)
      ** 'Midas ME SWIFTRef Service Directory
      *
      *
     D IAB3DS        E DS                  EXTNAME(MEIAB3PD)
      ** Midas ME SWIFTRef BANK DIRECTORY Plus - Inactive
      *
     D BIB3DS        E DS                  EXTNAME(MEBIB3PD)
      ** Midas ME SWIFTRef BANK DIRECTORY Plus
      *
      *
     D IASIDS        E DS                  EXTNAME(MEIASIPD)
      ** Midas ME SWIFTRef SSI Plus  Inactive
      *
     D SSIPDS        E DS                  EXTNAME(MESSIPPD)
      ** Midas ME SWIFTRef SSI Plus DIRECTORY
      *
      *
     D IAIBDS        E DS                  EXTNAME(MEIAIBPD)
      ** Midas ME SWIFTRef IBAN Plus DIRECTORY  Inactive
      *
     D IBN3DS        E DS                  EXTNAME(MEIBN3PD)
      ** Midas ME SWIFTRef IBAN Plus DIRECTORY
      *
      *
     D IASPDS        E DS                  EXTNAME(MEIASPPD)
      ** Midas ME Midas ME SWIFTRef SEPA Plus - Inactive
      *
     D SEPADS        E DS                  EXTNAME(MESEPAPD)
      ** Midas ME Midas ME SWIFTRef SEPA Plus
      *
      ** Data structure for ZDATE10
     D                 DS
     D  ZZDTIN                 1      8  0
     D  ZWYYYY                 1      4  0
     D  ZWMTH                  5      6  0
     D  ZWDAY                  7      8  0
      *
      ** Parameters for ZDATE10
     D DateIn          S                   LIKE(ZZDTIN)
     D DaynoOut        S              5P 0
      *
     D SJRDNB          S              5  0
     D ARUN            S              1
     D PRTCD           S              7
     D POPTN           S              7
      *
     D BICD            S              1
     D BICP            S              1
     D BICB            S              1
      *
     D KREFKY          S              8A   INZ
     D KIBNKY          S              2A   INZ
      *
      ** System Values details
     D PSysVal1        C                   CONST('BICDirUpdateCoB')
     D PSysVal2        C                   CONST('BICDBPlusUpdateCoB')
     D PSysVal3        C                   CONST('BICIBANPlusUpdateCoB')
      *
      ** Parameter variables for AOSVALR0 string
     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200
                                                                                              CSW218
     D CSW218          S              1A                                                      CSW218
      *
      /EJECT
      ** Main Program
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Perform different detailed processing
      *
     C                   EXSR      SRDETSD
      *
     C                   EXSR      SRDETB3
      *
     C                   EXSR      SRDETSI
      *
     C                   EXSR      SRDETN3
      *
     C                   EXSR      SRDETSP
      *
     C                   IF        BICD = 'Y' OR BICP = 'Y' OR BICB = 'Y'
     C                   EXSR      SRLOADER1
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   EXSR      SREND
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETSD -  SD Detail Processing                              *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDETSD       BEGSR
 
     C     *LOVAL        SETLL     MEIASDL0
     C                   READ      MEIASDL0
     C                   DOW       NOT(%EOF)
      *
     C                   IF        SDIFLDA <> *Blanks
     C                   MOVE      *BLANKS       ZZDTIN
     C                   MOVEL     SDIFLDA       ZZDTIN
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      SJRDNB = DaynoOut
     C
     C
     C                   IF        SJRDNB <= BJDNWD
      *
      ** Check if record already exists and create if not and necessary
      *
     C     SDIKEY        CHAIN     MEBISDL0                           99
     C                   IF        SDIFLAG = 'A'
     C                             OR SDIFLAG = 'M'
     C                             OR SDIFLAG = 'U'
     C                   EVAL      BISDDS = IASDDS
     C                   IF        NOT %FOUND(MEBISDL0)
     C                   WRITE     SDACTIV
     C                   ELSEIF    SDIFLAG = 'A'
     C                             OR SDIFLAG = 'M'
     C                   UPDATE    SDACTIV
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        SDIFLAG = 'D'
     C                              AND %FOUND(MEBISDL0)
     C                   DELETE    SDACTIV
     C                   ENDIF
      *
     C                   DELETE    SDINACT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEIASDL0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETB3 -  B3 Detail Processing                              *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDETB3       BEGSR
 
     C     *LOVAL        SETLL     MEIAB3L0
     C                   READ      MEIAB3L0
     C                   DOW       NOT(%EOF)
      *
     C                   IF        B3IFILA <> *Blanks
     C                   MOVE      *BLANKS       ZZDTIN
     C                   MOVEL     B3IFILA       ZZDTIN
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      SJRDNB = DaynoOut
     C
     C
     C                   IF        SJRDNB <= BJDNWD
      *
      ** Check if record already exists and create if not and necessary
      *
     C     B3IKEY        CHAIN     MEBIB3L0                           99
     C                   IF        B3IFLAG = 'A'
     C                             OR B3IFLAG = 'M'
     C                             OR B3IFLAG = 'U'
     C                   EVAL      BIB3DS = IAB3DS
     C                   IF        NOT %FOUND(MEBIB3L0)
     C                   WRITE     B3ACTIV
     C                   ELSEIF    B3IFLAG = 'A'
     C                             OR B3IFLAG = 'M'
     C                   UPDATE    B3ACTIV
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   IF        B3IFLAG = 'D'
     C                              AND %FOUND(MEBIB3L0)
      *
      *
     C                   IF        BICD  = 'Y'
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICDL3
     C                   IF        %FOUND(MEBICDL3)
     C                   DELETE    @BICDPD
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   IF        BICP = 'Y'
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICPL0
     C                   IF        %FOUND(MEBICPL0)
     C                   DELETE    @BICPPD
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   IF        BICB = 'Y'
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICBL0
     C                   IF        %FOUND(MEBICBL0)
     C                   DELETE    MEBICBD0
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   DELETE    B3ACTIV
     C                   ENDIF
      *
      *
     C                   DELETE    B3INACT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEIAB3L0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETSI -  SI Detail Processing                              *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDETSI       BEGSR
 
     C     *LOVAL        SETLL     MEIASIL0
     C                   READ      MEIASIL0
     C                   DOW       NOT(%EOF)
      *
     C                   IF        SIIFLDA <> *Blanks
     C                   MOVE      *BLANKS       ZZDTIN
     C                   MOVEL     SIIFLDA       ZZDTIN
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      SJRDNB = DaynoOut
     C
     C
     C                   IF        SJRDNB <= BJDNWD
      *
      ** Check if record already exists and create if not and necessary
      *
     C     SIIKEY        CHAIN     MESSIPL0                           99
     C                   IF        SIIFLAG = 'A'
     C                             OR SIIFLAG = 'M'
     C                             OR SIIFLAG = 'U'
     C                   EVAL      SSIPDS = IASIDS
     C                   IF        NOT %FOUND(MESSIPL0)
     C                   WRITE     SIACTIV
     C                   ELSEIF    SIIFLAG = 'A'
     C                             OR SIIFLAG = 'M'
     C                   UPDATE    SIACTIV
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        SIIFLAG = 'D'
     C                              AND %FOUND(MESSIPL0)
     C                   DELETE    SIACTIV
     C                   ENDIF
      *
     C                   DELETE    SIINACT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEIASIL0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETN3 -  N3 Detail Processing                              *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDETN3       BEGSR
 
     C     *LOVAL        SETLL     MEIAIBL0
     C                   READ      MEIAIBL0
     C                   DOW       NOT(%EOF)
      *
     C                   IF        N3IFLDA <> *Blanks
     C                   MOVE      *BLANKS       ZZDTIN
     C                   MOVEL     N3IFLDA       ZZDTIN
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      SJRDNB = DaynoOut
     C
     C
     C                   IF        SJRDNB <= BJDNWD
      *
      ** Check if record already exists and create if not and necessary
      *
     C     N3IKEY        CHAIN     MEIBN3L0                           99
     C                   IF        N3IFLAG = 'A'
     C                             OR N3IFLAG = 'M'
     C                             OR N3IFLAG = 'U'
     C                   EVAL      IBN3DS = IAIBDS
     C                   IF        NOT %FOUND(MEIBN3L0)
     C                   WRITE     N3ACTIV
     C                   ELSEIF    N3IFLAG = 'A'
     C                             OR N3IFLAG = 'M'
     C                   UPDATE    N3ACTIV
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        N3IFLAG = 'D'
     C                              AND %FOUND(MEIBN3L0)
     C                   DELETE    N3ACTIV
     C                   ENDIF
      *
     C                   DELETE    N3INACT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEIAIBL0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETSP -  SP Detail Processing                              *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRDETSP       BEGSR
 
     C     *LOVAL        SETLL     MEIASPL0
     C                   READ      MEIASPL0
     C                   DOW       NOT(%EOF)
      *
     C                   IF        SPIFLDA <> *Blanks
     C                   MOVE      *BLANKS       ZZDTIN
     C                   MOVEL     SPIFLDA       ZZDTIN
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      SJRDNB = DaynoOut
     C
     C
     C                   IF        SJRDNB <= BJDNWD
      *
      ** Check if record already exists and create if not and necessary
      *
     C     SPIKEY        CHAIN     MESEPAL0                           99
     C                   IF        SPIFLAG = 'A'
     C                             OR SPIFLAG = 'M'
     C                             OR SPIFLAG = 'U'
     C                   EVAL      SEPADS = IASPDS
     C                   IF        NOT %FOUND(MESEPAL0)
     C                   WRITE     SPACTIV
     C                   ELSEIF    SPIFLAG = 'A'
     C                             OR SPIFLAG = 'M'
     C                   UPDATE    SPACTIV
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        SPIFLAG = 'D'
     C                              AND %FOUND(MESEPAL0)
     C                   DELETE    SPACTIV
     C                   ENDIF
      *
     C                   DELETE    SPINACT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Next
      *
     C                   READ      MEIASPL0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLOADER1 - Amend old file for BANK DIRECTORY Plus Loader    *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls:  DO_BICD, DO_BICP and DO_BICB                         *
      *                                                               *
      *****************************************************************
      *
     C     SRLOADER1     BEGSR
      *
     C     *LOVAL        SETLL     MEBIB3L0
     C                   READ      MEBIB3L0
     C                   DOW       NOT(%EOF)
      *
     C                   IF        BICD  = 'Y'
     C                   EXSR      DO_BICD
     C                   ENDIF
      *
     C                   IF        BICP = 'Y'
     C                   EXSR      DO_BICP
     C                   ENDIF
      *
     C                   IF        BICB = 'Y'
     C                   EXSR      DO_BICB
     C                   ENDIF
      *
     C                   READ      MEBIB3L0
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICD - Update MEBICDPD Details                            *
      *                                                               *
      *  Called by: LOADER1                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICD       BEGSR
      *
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICDL3
     C                   IF        B3BICC <> *BLANKS
      *
     C                   MOVEL(P)  'BI'          D_BDTAG
     C                   MOVEL(P)  B3FLAG        D_BDMODF
     C                   MOVEL(P)  B3BICC        D_BDBICC
     C                   MOVEL(P)  B3BRCD        D_BDBICB
     C                   MOVEL(P)  B3INS1        D_BDINS1
     C                   MOVEL(P)  B3INS2        D_BDINS2
     C                   MOVEL(P)  B3INS3        D_BDINS3
     C                   MOVEL(P)  B3BIN1        D_BDBRC1
     C                   MOVEL(P)  B3BIN2        D_BDBRC2
     C                   MOVEL(P)  B3CITY        D_BDCITY
     C                   MOVEL(P)  B3STYP        D_BDSUBT
     C                   MOVEL(P)  B3SER1        D_BDADDS
     C                   MOVE      B3SER2        D_BDADDS
     C                   IF        CSW218 = 'Y'                                               CSW218
     C                   EVAL      %SUBST(D_BDXINF:19:1) = %SUBST(B3NWCY:1:1)                 CSW218
     C                   ELSE                                                                 CSW218
     C                   MOVEL(P)  *BLANKS       D_BDXINF
     C                   ENDIF                                                                CSW218
     C                   MOVEL(P)  B3ADD1        D_BDAPH1
     C                   MOVEL(P)  B3ADD2        D_BDAPH2
     C                   MOVEL(P)  B3ADD3        D_BDAPH3
     C                   MOVEL(P)  B3ADD4        D_BDAPH4
     C                   MOVEL(P)  B3ZIP         D_BDZIP
     C                   MOVEL(P)  B3CPS1        D_BDLOC1
     C                   MOVEL(P)  B3CPS2        D_BDLOC2
     C                   MOVEL(P)  B3CPS3        D_BDLOC3
     C                   MOVEL(P)  B3CNT1        D_BDCTY1
     C                   MOVEL(P)  B3CNT2        D_BDCTY2
     C                   MOVEL(P)  B3POBN        D_BDPOBN
     C                   MOVEL(P)  *BLANKS       D_BDPOB1
     C                   MOVEL(P)  *BLANKS       D_BDPOB2
     C                   MOVEL(P)  *BLANKS       D_BDPOB3
     C                   MOVEL(P)  *BLANKS       D_BDPBC1
     C                   MOVEL(P)  *BLANKS       D_BDPBC2
     C                   MOVEL(P)  *BLANKS       D_BDSRC
     C                   MOVEL(P)  *BLANKS       D_BDSPCD
     C                   MOVEL(P)  *BLANKS       D_BDNMFG
     C     6             SUBST     B3UDAT:3      D_BDUDAT
     C                   MOVEL(P)  *BLANKS       D_BDORGK
     C                   MOVEL(P)  B3FIL2        D_BDKEY
     C                   MOVEL(P)  B3CHIP        D_BDCHIP
     C                   MOVEL(P)  B3NATI        D_BDNATI
     C                   MOVEL(P)  *BLANKS       D_BDACTD
     C                   MOVEL(P)  *BLANKS       D_BDDACT
     C                   MOVEL(P)  *BLANKS       D_BDUMKY
     C                   MOVEL(P)  *BLANKS       D_BDUSER
     C                   MOVEL(P)  *BLANKS       D_BDCRS1
     C                   MOVEL(P)  *BLANKS       D_BDCRS2
     C                   MOVEL(P)  *BLANKS       D_BDCRS3
     C                   MOVEL(P)  *BLANKS       D_BDCRS4
     C                   MOVEL(P)  *BLANKS       D_BDCRD1
     C                   MOVEL(P)  *BLANKS       D_BDCRD2
     C                   MOVEL(P)  B3FILA        D_BDTRLR
     C                   EVAL      %SUBST(D_BDTRLR:36:35) = B3FLB1
     C                   EVAL      %SUBST(D_BDTRLR:71:8) = %SUBST(B3FLB2:1:8)
      *
     C                   IF        B3FLAG = 'A'
     C                             Or B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICDL3)
     C                   WRITE     @BICDPD
     C                   ELSE
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    @BICDPD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICP - Update MEBICPPD Details                            *
      *                                                               *
      *  Called by: LOADER1                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICP       BEGSR
      *
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICPL0
      *
     C                   MOVEL(P)  'BI'          P_BITAG
     C                   MOVEL(P)  B3FLAG        P_BIFLAG
     C                   MOVEL(P)  B3UBIC        P_BIBIC
     C                   EVAL      %SUBST(P_BIINST: 1:35) = B3INS1
     C                   EVAL      %SUBST(P_BIINST:36:35) = B3INS2
     C                   EVAL      %SUBST(P_BIINST:71:35) = B3INS3
     C                   MOVEL(P)  B3BIN1        P_BIBNCH
     C                   MOVE      B3BIN2        P_BIBNCH
     C                   MOVEL(P)  B3CITY        P_BICITY
     C                   MOVEL(P)  B3STYP        P_BISTYP
     C                   MOVEL(P)  B3SER1        P_BISERV
     C                   MOVE      B3SER2        P_BISERV
     C                   MOVEL(P)  *BLANKS       P_BIXINF
     C                   EVAL      %SUBST(P_BIADDR:  1:35) = B3ADD1
     C                   EVAL      %SUBST(P_BIADDR: 36:35) = B3ADD2
     C                   EVAL      %SUBST(P_BIADDR: 71:35) = B3ADD3
     C                   EVAL      %SUBST(P_BIADDR:106:35) = B3ADD4
     C                   MOVEL(P)  B3ZIP         P_BIZIP
     C                   MOVEL(P)  B3CITY        P_BILOCN
     C                   MOVEL(P)  B3CNT1        P_BICNTY
     C                   MOVEL     B3CNT2        P_BICNTY
     C                   MOVEL(P)  B3POBN        P_BIPOBN
     C                   MOVEL(P)  *BLANKS       P_BIPOBZ
     C                   MOVEL(P)  *BLANKS       P_BIPOBL
     C                   MOVEL(P)  *BLANKS       P_BIPOBC
     C                   MOVEL(P)  *BLANKS       P_BISRCI
     C                   MOVEL(P)  *BLANKS       P_BISPEC
     C                   MOVEL(P)  B3UDAT        P_BIUPDT
     C                   MOVEL(P)  *BLANKS       P_BIORIG
     C                   MOVEL(P)  B3FIL2        P_BIKEY
     C                   MOVEL(P)  *BLANKS       P_BICHCK
     C                   MOVEL(P)  B3CHIP        P_BICHIP
     C                   MOVEL(P)  B3NATI        P_BINATI
     C                   MOVEL(P)  *BLANKS       P_BIACTD
     C                   MOVEL(P)  *BLANKS       P_BIDCTD
     C                   MOVEL(P)  *BLANKS       P_BIUNDC
     C                   MOVEL(P)  *BLANKS       P_BIUNDN
     C                   MOVEL(P)  *BLANKS       P_BINKEY
     C                   MOVEL(P)  *BLANKS       P_BICFLG
     C                   MOVEL(P)  *BLANKS       P_BICINS
     C                   MOVEL(P)  *BLANKS       P_BIUSER
     C                   MOVEL(P)  *BLANKS       P_BICBI1
     C                   MOVEL(P)  *BLANKS       P_BICBI2
     C                   MOVEL(P)  *BLANKS       P_BICBI3
     C                   MOVEL(P)  *BLANKS       P_BICBI4
     C                   MOVEL(P)  *BLANKS       P_BICBD1
     C                   MOVEL(P)  *BLANKS       P_BICBD2
     C                   MOVEL(P)  *BLANKS       P_BIMFLG
     C                   MOVEL(P)  *BLANKS       P_BIMMTH
     C                   MOVEL(P)  *BLANKS       P_BIMRLT
     C                   MOVEL(P)  B3FILA        D_BDTRLR
     C                   EVAL      %SUBST(D_BDTRLR:36:35) = B3FLB1
     C                   EVAL      %SUBST(D_BDTRLR:71:8) = %SUBST(B3FLB2:1:8)
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICPL0)
     C                   WRITE     @BICPPD
     C                   ELSE
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    @BICPPD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICB - Update MEBICBPD Details                            *
      *                                                               *
      *  Called by: LOADER1                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICB       BEGSR
      *
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICBL0
      *
     C                   MOVEL(P)  B3BRQA        B_BIBRQA
     C                   MOVEL(P)  'BI'          B_BITAG
     C                   MOVEL(P)  B3FLAG        B_BIFLAG
     C                   MOVEL(P)  B3FIL2        B_BIKEY
     C                   EVAL      %SUBST(B_BIINST: 1:35) = B3INS1
     C                   EVAL      %SUBST(B_BIINST:36:35) = B3INS2
     C                   EVAL      %SUBST(B_BIINST:71:35) = B3INS3
     C                   EVAL      %SUBST(B_BIINST:71:35) = B3INS3
     C                   MOVEL(P)  B3CITY        B_BICITY
     C                   MOVEL(P)  B3BIN1        B_BIBINF
     C                   MOVE      B3BIN2        B_BIBINF
     C                   MOVEL(P)  B3BICC        B_BIBICC
     C                   MOVEL(P)  B3BRCD        B_BIBRCD
     C                   MOVEL(P)  B3BICC        B_BIUBIC
     C                   MOVEL(P)  B3BRCD        B_BIUBRC
     C                   MOVEL(P)  *BLANKS       B_BIIBIC
     C                   MOVEL(P)  *BLANKS       B_BIIBRC
     C                   MOVEL(P)  *BLANKS       B_BIRBIC
     C                   EVAL      B_BIPBCD = %SUBST(B3BICC:1:4)
     C                   MOVEL(P)  B3ISOC        B_BICTCD
     C                   MOVEL(P)  B3NATI        B_BINATI
     C                   MOVEL(P)  B3NATI        B_BIUNTI
     C                   MOVEL(P)  B3ISOC        B_BIICTY
     C                   MOVEL(P)  B3NATI        B_BIINAT
     C                   MOVEL(P)  B3NATI        B_BIUIND
     C                   MOVEL(P)  *BLANKS       B_BIOND1
     C                   MOVEL(P)  *BLANKS       B_BIOND2
     C                   MOVEL(P)  B3CHIP        B_BICHIP
     C                   MOVEL(P)  B3STYP        B_BISTYP
     C                   MOVEL(P)  B3SER1        B_BISERV
     C                   MOVE      B3SER2        B_BISERV
     C                   MOVEL(P)  B3BRQA        B_BIBRQA
     C                   MOVEL(P)  *BLANKS       B_BISPCD
     C                   EVAL      %SUBST(B_BIADDR:  1:35) = B3ADD1
     C                   EVAL      %SUBST(B_BIADDR: 36:35) = B3ADD2
     C                   EVAL      %SUBST(B_BIADDR: 71:35) = B3ADD3
     C                   EVAL      %SUBST(B_BIADDR:106:35) = B3ADD4
     C                   MOVEL(P)  B3ZIP         B_BIZIP
     C                   MOVEL(P)  *BLANKS       B_BILOCN
     C                   MOVEL(P)  B3CNT1        B_BICNTY
     C                   MOVE      B3CNT2        B_BICNTY
     C                   MOVEL(P)  B3POBN        B_BIPOBN
     C                   MOVEL(P)  *BLANKS       B_BIPOBZ
     C                   MOVEL(P)  *BLANKS       B_BIPLOC
     C                   MOVEL(P)  *BLANKS       B_BIPCNT
     C                   MOVEL(P)  *BLANKS       B_BINDED
     C                   MOVEL(P)  B3UDAT        B_BIUDAT
      *
     C                   IF        B3FLAG = 'A'
     C                             Or B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICBL0)
     C                   WRITE     MEBICBD0
     C                   ELSE
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    MEBICBD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT  -  Initial Processing                                *
      *  Called by: Main routine                                      *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ME1753'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBTXT = *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST  '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve the system value
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      PSysVal1      SVALK1
     C                   PARM      *BLANKS       SVAL1
     C                   PARM      PSysVal2      SVALK2
     C                   PARM      *BLANKS       SVAL2
     C                   PARM      PSysVal3      SVALK3
     C                   PARM      *BLANKS       SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      ** If the system values are not found then issue a database error
 
     C     PRTCD         IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CLEAR                   BICD
     C                   CLEAR                   BICP
     C                   CLEAR                   BICB
     C                   EVAL      BICD  =  SVAL1
     C                   EVAL      BICP  =  SVAL2
     C                   EVAL      BICB  =  SVAL3
      *                                                                                       CSW218
      ** Check if Swift 2018 Changes is installed.                                            CSW218
      *                                                                                       CSW218
     C                   CALL      'SWIF2018'                                                 CSW218
     C                   PARM      *BLANKS       PRTCD                                        CSW218
      *                                                                                       CSW218
     C     PRTCD         IFEQ      'CSW2018'                                                  CSW218
     C                   EVAL      CSW218 = 'Y'                                               CSW218
     C                   ELSE                                                                 CSW218
     C                   EVAL      CSW218 = 'N'                                               CSW218
     C                   ENDIF                                                                CSW218
      *
      ***  Key list definition
      *
     C     KBICF         KLIST
     C                   KFLD                    KREFKY
      *
     C     KCCDF         KLIST
     C                   KFLD                    KIBNKY
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREND   -  End Program                                       *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  File Exception/Error Handling Subroutine          *
      *  Called by: Various                                           *
      *  Calls    : DBERRCTL - DB Error Control                       *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     ARUN          IFEQ      *BLANK
     C                   EVAL      ARUN = 'Y'
     C                   DUMP
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EXSR      SREND
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
