     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Generate Global Account Codes & Mappings')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGENGACD - Generate Global Account Codes and Mappings       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG6789            Date 21Apr05               *
      *                 CGP010   *CREATE   Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6789- Initialize fields on GPACODXPD                      *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDACODL1IF   E           K DISK    INFSR(*PSSR)
     FGPACODL0  IF A E           K DISK    INFSR(*PSSR)
     FGPACODXL0 UF A E           K DISK    INFSR(*PSSR)
 
 
     C     GZSDACODK     SETLL     GZSDACODL1
     C     GZSDACODK     READE     GZSDACODL1                             99
 
      * Read all account codes for zone
 
     C     *IN99         DOWEQ     *OFF
     C                   EVAL      ACGACD = A5ACCD
     C                   EVAL      ACDESC = A5ACCN
     C                   EVAL      %SubST(ACDESC:24:2) = ' '
     C                   EVAL      ACACSC = A5ACSC
     C                   EVAL      ACLCD  = BJRDNB
     C                   EVAL      ACCHTP = 'I'
     C                   EVAL      ACTOIN = A5TOIN
 
      * Write a global account code
 
     C     GPACODK       CHAIN     GPACODD0                           99        *
     C   99              WRITE     GPACODD0
     C                   EVAL      ACZONE = O#ZONE
     C                   EVAL      ACACCD = A5ACCD
     C                   EVAL      ACGACD = ACGACD
     C                   EVAL      ACGPRD = ' '                                              BUG6789
     C                   EVAL      ACGINS = ' '                                              BUG6789
 
      * Write/Update a global account code mapping
 
     C     GPACODXK      CHAIN     GPACODXD0                          99        *
     C   99              WRITE     GPACODXD0
     C  N99ACGACD        IFEQ      *BLANK
     C                   EVAL      ACGACD = A5ACCD
     C                   UPDATE    GPACODXD0
     C                   ENDIF
 
     C     GZSDACODK     READE     GZSDACODL1                             99
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C                   CALL      'GOGETZONE'
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      'N'           I#FULLCHECK       1
      * OUTPUTS
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0
 
      * No zone
 
     C     O#ZONE        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO ZONE PRESENT'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * No bank details for zone
 
     C     O#ZONE        CHAIN     SDBANKD0                           99
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'MISSING GZSDBANKPD RECORD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Key lists
 
     C     GZSDACODK     KLIST
     C                   KFLD                    O#ZONE
     C     GPACODK       KLIST
     C                   KFLD                    ACGACD
     C     GPACODXK      KLIST
     C                   KFLD                    ACZONE
     C                   KFLD                    ACACCD
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
