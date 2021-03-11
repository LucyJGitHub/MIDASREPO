     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for Accounts')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCACCT - Extract Controller for Accounts                   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FACCNT     IF   E           K DISK    INFSR(*PSSR) INCLUDE(ACCNTABF)


     D/COPY ZACPYSRC,STD_D_SPEC


     D ACCT          E DS                  EXTNAME(ACCNTAB)


     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL ACCOUNTS
      * OR EXTRACT A SINGLE ACCOUNT
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL ACCOUNTS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      ACCNTABF                               99    *
      *
      * Whilst accounts can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract open accounts
      *
     C     RECI          IFEQ      'D'
     C                   EXSR      EXTRCT
     C                   END
      *
      * Read the next record
      *
     C                   READ      ACCNTABF                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE ACCOUNT
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C**********         MOVEL     I#CNUM        W#CNUM            6 0                        CSD027
     C                   MOVEL     I#CNUM        W#CNUM            6                          CSD027
     C                   MOVEL     I#ACCY        W#CCY             3
     C**********         MOVEL     I#ACOD        W#ACOD            4 0                        CGL029
     C                   MOVEL     I#ACOD        W#ACOD           10 0                        CGL029
     C                   MOVEL     I#ACSQ        W#ACSQ            2 0
     C                   MOVEL     I#BRCA        W#BRCA            3
     C     ACCNTK        CHAIN     ACCNTABF                           99        *
      *
      * If the account is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
     C                   CALLB     'GOXTACCT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0

     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      I#AMRD        W#AMRD            5 0
     C                   PARM                    ACCT

      * If data error encountered, log error

     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'ACCT' + I#EXTT + I#TREF
     C                                    + W#RTCD + W#ERMS + ACCT
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

      * Get Extract control information

      /COPY GOCPYSRC,GOGETEXCT


      * key lists

     C     ACCNTK        KLIST
     C                   KFLD                    W#CNUM
     C                   KFLD                    W#CCY
     C                   KFLD                    W#ACOD
     C                   KFLD                    W#ACSQ
     C                   KFLD                    W#BRCA
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
