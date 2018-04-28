     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Take on of Stamp Tax Account Take on')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD008197 - Midas Take on of Stamp Tax Account Take on        *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd. 2010  *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      *  Prev Amend No. AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables             *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GL Accounts master
     FACCNT     IF   E           K DISK    IGNORE(ACCNTAAF:ACCNTACF)
     F                                     INFSR(*PSSR)
 
     FGLACNTL3  UF A E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D @CUST           S              6A
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      ** External DS for RUNDAT DataArea Layout file
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
 
     C                   DOU       %EOF(ACCNT)
     C                   READ      ACCNT
 
     C                   MOVE      CNUM          @CUST
     C                   IF        NOT(%EOF(ACCNT))
     C                   IF        ATYP = 'R' And
     C                             @CUST <> BJCUST
 
     C**********         EVAL      F1BRCA = BRCA                                            AR847269
     C**********         EVAL      F1CNUM = CNUM                                            AR847269
     C**********         EVAL      F1CCY  = CCY                                             AR847269
     C**********         EVAL      F1ACOD = ACOD                                            AR847269
     C**********         EVAL      F1ACSQ = ACSQ                                            AR847269
     C**********         EVAL      F1DBRC = BRCA                                            AR847269
     C**********         EVAL      F1DCST = CNUM                                            AR847269
     C**********         EVAL      F1DACD = ACOD                                            AR847269
     C**********         EVAL      F1DASC = ACSQ                                            AR847269
     C**********         EVAL      F1CDTE = DACO                                            AR847269
     C**********         EVAL      F1TAX  = 'Y'                                             AR847269
     C**********         EVAL      F1AVBL = 'Y'                                             AR847269
 
     C     KGLACNTQD     CHAIN     GLACNTL3
     C                   EVAL      F1TAX  = 'Y'                                             AR847269
     C                   EVAL      F1CLOS = 'N'                                             AR847269
     C                   EVAL      F1AVBL = 'Y'                                             AR847269
     C                   EVAL      F1ADTE = BJRDNB                                          AR847269
     C                   EVAL      F1FREE = *ZEROS                                          AR847269
     C                   EVAL      F1FEDT = *ZEROS                                          AR847269
     C                   EVAL      F1SINT = 'Y'                                             AR847269
     C                   EVAL      F1IDTE = BJRDNB                                          AR847269
     C                   EVAL      F1DBRC = BRCA                                            AR847269
     C                   EVAL      F1DCST = CNUM                                            AR847269
     C                   EVAL      F1DCCY = CCY                                             AR847269
     C                   EVAL      F1DACD = ACOD                                            AR847269
     C                   EVAL      F1DASC = ACSQ                                            AR847269
     C                   EVAL      F1STAB = *ZEROS                                          AR847269
     C                   EVAL      F1STAI = *ZEROS                                          AR847269
     C                   EVAL      F1TAXE = *ZEROS                                          AR847269
     C                   EVAL      F1CDTE = BJRDNB                                          AR847269
     C                   EVAL      F1CCFL = 'Y'                                             AR847269
     C                   EVAL      F1SDTE = BJRDNB                                          AR847269
     C                   EVAL      F1STCC = *ZEROS                                          AR847269
     C                   MOVEL     ACOD          TAcod            12                        AR847269
     C                   MOVE      ACSQ          TAcod                                      AR847269
     C                   EVAL      F1DACN =  BRCA + CNUM + CCY + TAcod                      AR847269
     C                   IF        %FOUND(GLACNTL3)
     C**********         EVAL      F1CDTE  = 10594                                          AR847269
     C                   UPDATE    GLACNTD0
     C**********         ELSE                                                               AR847269
     C**********         WRITE     GLACNTD0                                                 AR847269
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     KGLACNTQD     KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        @RTCD <> *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
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
      ****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd., 2010
