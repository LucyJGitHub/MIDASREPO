     H DEBUG
     H COPYRIGHT('(c) Misys Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  CVTOPT(*VARCHAR)                                             *
/*EXI *  TEXT('Midas GL Trigger on GLJENHPD')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  EML102UPD - Midas GL Trigger on GLJENHPD                     *
      *                                                               *
      *  Function :  Duplicate T_GZBITPEX to zone file PF/GLJENPY0    *
      *              on acceptance of Batch only (EML102)             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2019            *
      *                                                               *
      *  Last Amend No. EML102  *CREATE    Date 28Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML102 - Upgrade of UNL007 to FB2.1 SP21                     *
      *           UNL007 - Extended Narratives                        *
      *                                                               *
      *****************************************************************

     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)  USROPN
      ***  Retriev Zone for Global branches File
      *
     FGZBITPV0  IF   E           K DISK    INFSR(*PSSR)  USROPN
      *** batch items - Ext. narratives
      *
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)  USROPN    COMMIT(D_COM)
      *** batch items - Master file
      *
     FGLJENPY0  UF A E           K DISK    INFSR(*PSSR)  USROPN    COMMIT(D_COM)
      ***  Ext. narrative for Batch Items accepted
     F                                     Prefix(O_)
O
O    D Z_JENH_BEF    E DS                  EXTNAME(GZGLJENHPD) PREFIX(B_)
O    D Z_JENH_AFT    E DS                  EXTNAME(GZGLJENHPD)

      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     *** compare images (only call on updates)
O
     C                   EVAL      I#ERMS = 'EML102UPD - MAINLINES    '
O    C                   MOVEL     I#BIMG        Z_JENH_BEF
O    C                   MOVEL     I#AIMG        Z_JENH_AFT
      *
     C                   EVAL      I#ERMS = 'EML102UPD Bef=' + B_BRBTSF +
     C                                      ', after = ' + BRBTSF + '.'
      *
     C                   if        B_BRBTSF = 'H' and BRBTSF = 'A'
     C                   EVAL      I#ERMS = 'EML102UPD - OPEN         '
     C                   OPEN      GLJENPY0                             99
     C                   OPEN      GZBITPV0                             99
     C                   OPEN      GLJENPL1                             99

      ***  Access branch to retrieve Zone value (A8ZONE)

     C                   OPEN      GZSDBRCHL0                           99
     C                   EVAL      I#ERMS = 'EML102UPD - OPEN DONE    '
     C     BRBCDA        CHAIN     GZSDBRCHL0                         99
     C     *IN99         IFEQ      *ON
     C                   Eval      I#ERMS = BRBCDA + 'not in GZSDBRCHL0'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   CLOSE     GZSDBRCHL0                           99
     C                   EVAL      I#ERMS = 'EML102UPD - A8ZONE =' +A8ZONE + '.'
      *
      ***  read All items of a Batch and duplicate if necessary
      *
     C                   EVAL      I#ERMS = 'EML102UPD - READ GZBITPEX'
     C     KEY_READ      CHAIN     GZBITPEX                           99
      *
     C                   DOW       not %EOF(GZBITPV0)
     C                   EVAL      I#ERMS = 'EML102UPD - HDL  GZBITPEX'
      *
      ***  Preapare key write fields and
      ***  Access Master File for Batch item details (need field BTPTDT)
      *
     C                   MOVE      EXBINB        XXBINB            3 0
      *
     C                   EVAL      I#ERMS = 'EML102UPD - READ GLJENPL1'
     C     KEY_READ2     CHAIN     GLJENPL1
     C                   IF        %found(GLJENPL1)
     C                   EVAL      I#ERMS = 'EML102UPD - HDL  GLJENPL1'
      *
      ***  verify if a record exist or not to target file GLJENPX0
      ***  normally not but if this is the case erase it

     C                   Move      BTBINB        EXBINB
     C                   MOVE      BTPTDT        XXPSTD            5 0
      *
     C                   EVAL      I#ERMS = 'EML102UPD - READ GLJENPD2'
     C     KEY_WRITE     CHAIN     GLJENPD2                           89
     C                   EVAL      I#ERMS = 'EML102UPD - HDL  GLJENPD2'
     C                   EvalR     O_FNA02  = EXNA2
     C                   EvalR     O_FNA03  = EXNA3
     C                   EvalR     O_FNA04  = EXNA4
     C                   EvalR     O_FNA05  = EXNA5
     C                   EvalR     O_FNA06  = EXNA6
     C                   EvalR     O_FNA07  = EXNA7
     C                   EvalR     O_FNA08  = EXNA8
     C                   EvalR     O_FNA09  = EXNA9
     C                   EvalR     O_FNA10  = EXNA10
     C                   EvalR     O_FNA11  = EXNA11
     C                   EvalR     O_FNA12  = EXNA12
     C                   EvalR     O_FNA13  = EXNA13
     C                   EvalR     O_FNA14  = EXNA14
     C                   EvalR     O_FNA15  = EXNA15
     C                   EvalR     O_FNA16  = EXNA16
     C                   EvalR     O_FNA17  = EXNA17
      *
     C                   IF        %found(GLJENPY0)
     C                   EVAL      I#ERMS = 'EML102UPD - UPDT GLJENPD2'
     C                   Update    GLJENPD2
     C                   EVAL      I#ERMS = 'EML102UPD - Updated      '
     C                   ELSE
     C                   EVAL      I#ERMS = 'EML102UPD - ISRT GLJENPD2'
     C                   EVAL      O_FBTNB  = EXBTNB
     C                   EVAL      O_FBINB  = XXBINB
     C                   EVAL      O_FPTDT  = XXPSTD
     C                   Write     GLJENPD2
     C                   EVAL      I#ERMS = 'EML102UPD - Inserted     '
     C                   Endif
      *
     C                   Endif

      ***  next Batch Item with UDF Details
      *
     C     KEY_READ      READE     GZBITPEX                               99
     C                   ENDDO

O    C                   CLOSE     GLJENPL1                             99
O    C                   CLOSE     GZBITPV0                             99
O    C                   CLOSE     GLJENPY0                             99
     C                   Endif
     C                   EVAL      I#ERMS = 'EML102UPD - Leave        '

     C                   RETURN

     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
     C                   EVAL      I#ERMS = 'EML102UPD - CALL GPCOPN4COM '
     C                   CALL      'GPCOPN4COM'
     C                   PARM                    D_COM             1
     C                   EVAL      I#ERMS = 'EML102UPD - GPCOPN4COM OK'
O
O     * Key lists
O
O    C     KEY_READ      KLIST
     C                   KFLD                    A8ZONE
O    C                   KFLD                    BRBTNB
      *
O    C     KEY_READ2     KLIST
     C                   KFLD                    BRBTNB
O    C                   KFLD                    XXBINB
      *
     C     KEY_Write     KLIST
     C                   KFLD                    EXBTNB
     C                   KFLD                    XXBINB
     C                   KFLD                    XXPSTD
      *

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR

     C     W#RUN         IFEQ      *BLANKS

     C                   MOVE      'Y'           W#RUN             1

     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8

     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'EML102UPD - UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000

     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
