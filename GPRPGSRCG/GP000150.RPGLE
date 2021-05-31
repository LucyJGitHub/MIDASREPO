     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000150 - Update program of GPFCAMPD file                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2018            *
      *                                                               *
      *  Last Amend No. MD049445 *Create   Date 20Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD049445 - Listview not displaying correct available amount. *
      *             Added SFAMT and SAVAILAMT computation.            *
      *                                                               *
      *****************************************************************

     FGZLEFCAML0IF   E           K DISK    INFSR(*PSSR)
     FGZLEFCAML1IF   E           K DISK    INFSR(*PSSR) PREFIX(G_)
     F                                     RENAME(LEFCAMPF  :LEFCAMP2     )
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
     FGPFCAML0  UF   E           K DISK    INFSR(*PSSR) PREFIX(G1_)
     F                                     COMMIT(D_COM) USROPN
     FGPFCAMPD  O  A E           K DISK    INFSR(*PSSR) PREFIX(G1_)
     F                                     RENAME(GPFCAMD0  :GPFCAMD2     )
O    F                                     COMMIT(D_COM) USROPN

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    WZONE            10

      * get rundate
     C     WZONE         CHAIN     GZSDBANKL1                         99

      * Global File Update

     C                   EXSR      SRDELF
     C                   EXSR      SRUPDF

     C                   RETURN

      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SRDELF - Delete all records not found in GZLEFCAMPD for this zone
      ********************************************************************
     C     SRDELF        BEGSR
     C     *LOVAL        SETLL     GPFCAML0
     C                   READ      GPFCAML0                               98
     C     *IN98         DOWEQ     *OFF
     C                   IF        WZONE = G1_GZONE
     C     K_GZLEFCAML1  CHAIN     LEFCAMP2                           93
     C     *IN93         IFEQ      *ON
     C                   DELETE    GPFCAML0
     C                   ENDIF
     C                   ENDIF
     C                   READ      GPFCAML0                               98
     C                   ENDDO
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SRUPDF - Write/update GPFCAMPD file.
      ********************************************************************
     C     SRUPDF        BEGSR
     C     *LOVAL        SETLL     LEFCAMPF
     C                   READ      LEFCAMPF                               97
     C     *IN97         DOWEQ     *OFF
     C     BRCA          CHAIN     GZSDBRCHL0                         96
      * if same zone, process
     C                   IF        WZONE = A8ZONE
     C                   EVAL      G1_GBRCA = BRCA
     C                   EVAL      G1_GCNUM = CNUM
     C                   EVAL      G1_GFACT = FACT
     C                   EVAL      G1_GFCNO = FCNO
      * check if exist
     C     K_GZLEFCAML1  CHAIN     GPFCAML0                           94
     C                   EVAL      G1_GZONE = WZONE
     C                   EVAL      G1_GAAMT = 0
      * compute for FIFD
     C     K_GZLEFCAML1  SETLL     LEFCAMP2
     C     K_GZLEFCAML1  READE     LEFCAMP2                               95
     C     *IN95         DOWEQ     *OFF
     C                   IF        G_RECI = 'D'
     C                   IF        G_FATP = 'FI'
     C                             AND G_VLDT <= BJRDNB
     C                   EVAL      G1_GAAMT = G1_GAAMT + G_AAMT
     C                   ENDIF
     C                   IF        G_FATP = 'FD'
     C                             AND G_VLDT <= BJRDNB
     C                   EVAL      G1_GAAMT = G1_GAAMT - G_AAMT
     C                   ENDIF
     C                   ENDIF
     C     K_GZLEFCAML1  READE     LEFCAMP2                               95
     C                   ENDDO
      * update file
     C     *IN94         IFEQ      *OFF
     C                   UPDATE    GPFCAMD0
     C                   ELSE
     C                   WRITE     GPFCAMD2
     C                   ENDIF
     C                   ENDIF
     C                   READ      LEFCAMPF                               97
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR

      * Open for commit?

     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   OPEN      GPFCAML0
     C                   OPEN      GPFCAMPD

      * Key lists

     C     K_GZLEFCAML1  KLIST
     C                   KFLD                    G1_GBRCA
     C                   KFLD                    G1_GCNUM
     C                   KFLD                    G1_GFACT
     C                   KFLD                    G1_GFCNO


     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR

     C     W#RUN         IFEQ      *BLANKS

     C                   MOVE      'Y'           W#RUN             1

     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8

     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *********************************************************************