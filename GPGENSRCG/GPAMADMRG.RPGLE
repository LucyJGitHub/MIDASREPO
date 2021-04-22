     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*S*D****RPGBASEBNC****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Generated Code')                                       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAMADMRG  - On-Line Update of Global File GPAMADPD          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 MD026387           Date 13May14               *
      *                 CGP017             Date 06Aug12               *
      *                 AR1090088          Date 20Feb13               *
      *                 AR1047824          Date 07Feb13               *
      *                 AR645170           Date 16Sep11               *
      *                 CSF011             Date 12Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256612A            Date 09Oct08               *
      *                 254797             Date 12Jun08               *
      *                 BUG16715*Create    Date 14Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD026387 - Reconciliation issue with GPAMADPD                *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  AR1090088 - Branch customer on account maintenance is wrong  *
      *            - This is the BF2.1 corrected version of AR1047824 *
      *  AR1047824 - Branch customer on account maintenance is wrong  *
      *              (Child: AR1047825)                               *
      *  AR645170 - GL: Accounts is not present on file ACCNTAB but   *
      *             present in the Java Listview. Add commit to file  *
      *             so that GPAMADPD will be properly rollback when   *
      *             unsuccesfull write to PF/ACCNTAB.                 *
      *             (Child: AR818797)                                 *
      *  CSF011 - Customer Name on Inputs (Recompile)                 *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256612A - Prevent conflict if there is an existing open      *
      *            file with commitment control left by a previous    *
      *            program                                            *
      *  254797 - GL wrong accounts search form                       *
      *  BUG16715 - Slow performance unable to locate an Account      *
      *                                                               *
      *****************************************************************

O    FGZACCNTBL1IF   E           K DISK    PREFIX(G_) INFSR(*PSSR)
O    FGZREIACDL1IF   E           K DISK    PREFIX(G_) INFSR(*PSSR)
O    FGZRECOMDL1IF   E           K DISK    PREFIX(G_) INFSR(*PSSR)
O    FGZSDACODL1IF   E           K DISK    PREFIX(G_) INFSR(*PSSR)
O    FGPGLCUSLL1IF   E           K DISK    PREFIX(G_) INFSR(*PSSR)
     F                                     USROPN                                            256612A
O    FGPAMADL0  UF A E           K DISK    PREFIX(G_) INFSR(*PSSR)
     F                                     COMMIT(D_COM) USROPN                             AR645170
O    FGZSDCUSTL0IF   E           K DISK    PREFIX(G_) INFSR(*PSSR)                         AR1090088
O    FGZSDBRCHL1IF   E           K DISK    PREFIX(Z_) INFSR(*PSSR)                         AR1090088
O
O    D Z_ACCNTAB     E DS                  EXTNAME(GZACCNTAB )
O    D G_ACCNTAB     E DS                  EXTNAME(GZACCNTAB ) PREFIX(G_)
     D*SDCUST********E*DS******************EXTNAME(SDCUSTPD)                     AR1047824 AR1090088
      ***External*DS*for*Customer*Details                                        AR1047824 AR1090088
     D*DSLDY*********E*DS******************EXTNAME(DSLDY)                        AR1047824 AR1090088
      **Third*DS*for*access*programs,*very*long*data*structure                   AR1047824 AR1090088

     D CmdArray        S             80A   DIM(2) CTDATA PERRCD(1)                           256612A
     D Cmd             S             80A                                                     256612A
     D Len             S             15P 5                                                   256612A
                                                                                             256612A
      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        Z_ACCNTAB
O    C                   ELSE
O    C                   MOVEL     I#AIMG        Z_ACCNTAB
O    C                   ENDIF
O
O    C     K_GZACCNTL1   CHAIN     GPAMADL0                           99
O
O     * 'Before'
O
O    C     I#BFAF        IFEQ      'B'
O    C                   IF        %FOUND(GPAMADL0)
O    C                   DELETE    AMADREC
O    C                   ENDIF
O    C                   ELSE
O
O     * 'After'
O
O    C                   CLEAR                   G_ACCNTAB
O    C                   MOVEL     Z_ACCNTAB     G_ACCNTAB
O     * Fix Data
O    C**********         CALL      'GPFIXGDTA'                                                CGP017
     C                   CALLB     'GPFIXGDTA'                                                CGP017
O    C                   PARM                    I#ZONE
O    C                   PARM      'GZACCNTAB '  I#FILE           10
O    C                   PARM      G_ACCNTAB     IO#BUFFER      4000
O    C                   MOVEL     IO#BUFFER     G_ACCNTAB
O     * Update
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    AMADREC
O    C                   ELSE
     C                   EXSR      GENAMAD
O    C                   ENDIF
O    C                   ENDIF

     C                   RETURN

      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     GENAMAD       BEGSR
     C                   EXSR      OPENFILE                                                  256612A

     C                   EVAL      G_CUSTZONE = I#ZONE
     C                   MOVEL     ACOD          G_PADACOD
     C                   MOVEL     ACOD          ACCD
     C     CNUM          CHAIN     GZSDCUSTL0                                               MD026387
O    C     K_GZACCNTL1   CHAIN     GZACCNTBL1                         98
O    C     K_GZACCNTL1   CHAIN     GZREIACDL1                         97
O    C     K_GZACCNTL2   CHAIN     GZRECOMDL1                         96
O    C     K_GZACODL1    CHAIN     GZSDACODL1                         95
O    C     K_GZCUSGL1    CHAIN     GPGLCUSLL1                         94

     C                   IF        *IN94 = *ON                                                254797
     C                   EVAL      G_CGGLOB = *BLANKS                                         254797
     C                   EVAL      G_CGCSSN = *BLANKS                                         254797
     C                   EVAL      G_CGRNM  = *BLANKS                                         254797
     C                   EVAL      G_CGRTN  = *BLANKS                                         254797
     C                   EVAL      G_CGICD  = *BLANKS                                         254797
     C                   EVAL      G_CGACO  = *BLANKS                                         254797
     C                   EVAL      G_CGCNCZ = *BLANKS                                         254797
     C                   EVAL      G_CGCOLC = *BLANKS                                         254797
     C                   EVAL      G_CGBRCD = *BLANKS                                         254797
     C                   EVAL      G_CGCUST = *BLANKS                                         254797
     C                   EVAL      G_CGZONE = *BLANKS                                         254797
     C**********         EVAL      G_CGGLOB = BRCA + '-' + CNUM                     254797 AR1047824
      **********                                                                 AR1047824 AR1090088
     C**********         EVAL      PKEY10   = CNUM                               AR1047824 AR1090088
     C**********         EXSR      RTVCUST                                       AR1047824 AR1090088
     C**********         IF        PRTCD    = *BLANKS                            AR1047824 AR1090088
     C**********         EVAL      G_CGGLOB = BBBRCD + '-' + CNUM                AR1047824 AR1090088
     C**********         ELSE                                                    AR1047824 AR1090088
     C**********         EVAL      G_CGGLOB = *BLANKS                            AR1047824 AR1090088
     C**********         ENDIF                                                   AR1047824 AR1090088
      **********                                                                 AR1047824 AR1090088
      ** Set Global Customer Number                                                        AR1090088
     C                   EXSR      SETCUST                                                 AR1090088
                                                                                           AR1090088
     C                   ENDIF                                                                254797
                                                                                              254797
O    C                   WRITE     AMADREC

     C                   EXSR      CLOSEFIL                                                  256612A
     C                   ENDSR
     C/SPACE 5                                                                               256612A
      *****************************************************************                      256612A
      * OPENFILE - Put override, no share and open input files                               256612A
      *****************************************************************                      256612A
     C     OPENFILE      BEGSR                                                               256612A
     C                   MOVEA     CmdArray(1)   Cmd                                         256612A
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPGLCUSLL1'                          256612A
     C                   Z-ADD     80            Len                                         256612A
     C                   CALL      'QCMDEXC'                                                 256612A
     C                   PARM                    Cmd                                         256612A
     C                   PARM                    Len                                         256612A
                                                                                             256612A
     C                   OPEN      GPGLCUSLL1                                                256612A
      *                                                                                      256612A
     C                   ENDSR                                                               256612A
     C/SPACE 5                                                                               256612A
      *****************************************************************                      256612A
      * CLOSEFIL - Delete overrides and close input files                                    256612A
      *****************************************************************                      256612A
     C     CLOSEFIL      BEGSR                                                               256612A
     C                   CLOSE     GPGLCUSLL1                                                256612A
                                                                                             256612A
     C                   MOVEA     CmdArray(2)   Cmd                                         256612A
     C                   EVAL      %SUBST(Cmd:13:10) = 'GPGLCUSLL1'                          256612A
     C                   Z-ADD     80            Len                                         256612A
     C                   CALL      'QCMDEXC'                                                 256612A
     C                   PARM                    Cmd                                         256612A
     C                   PARM                    Len                                         256612A
     C                   ENDSR                                                               256612A
     C***/SPACE*5                                                                AR1047824 AR1090088
      *****************************************************************                    AR1047824
      **RTVCUST*-*Retrieve*Customer*Details                                      AR1047824 AR1090088
      *****************************************************************                    AR1047824
     C*****RTVCUST       BEGSR                                                   AR1047824 AR1090088
      **********                                                                 AR1047824 AR1090088
     C**********         CALL      'AOCUSTR1'                                    AR1047824 AR1090088
     C**********         PARM      *BLANKS       PRTCD             7             AR1047824 AR1090088
     C**********         PARM      '*KEY   '     POPTN             7             AR1047824 AR1090088
     C**********         PARM                    PKEY10           10             AR1047824 AR1090088
     C**********         PARM      *BLANKS       PKEY7             7             AR1047824 AR1090088
     C*****SDCUST        PARM      SDCUST        DSLDY                           AR1047824 AR1090088
      **********                                                                 AR1047824 AR1090088
     C**********         ENDSR                                                   AR1047824 AR1090088
     C/SPACE 5                                                                             AR1090088
      *****************************************************************                    AR1090088
      * SETCUST - Set Global Customer Number                                               AR1090088
      *****************************************************************                    AR1090088
     C     SETCUST       BEGSR                                                             AR1090088
                                                                                           AR1090088
     C                   EVAL      G_CGGLOB = *BLANKS                                      AR1090088
     C     CNUM          SETLL     GZSDCUSTL0                                              AR1090088
     C     CNUM          READE     GZSDCUSTL0                                              AR1090088
                                                                                           AR1090088
     C                   DOW       NOT %EOF(GZSDCUSTL0)                                    AR1090088
     C     K_GZBRCHL1    CHAIN     GZSDBRCHL1                                              AR1090088
     C                   IF        %FOUND(GZSDBRCHL1)                                      AR1090088
     C                   EVAL      G_CGGLOB = G_BBBRCD + '-' + CNUM                        AR1090088
     C                   LEAVESR                                                           AR1090088
     C                   ENDIF                                                             AR1090088
                                                                                           AR1090088
     C     CNUM          READE     GZSDCUSTL0                                              AR1090088
     C                   ENDDO                                                             AR1090088
                                                                                           AR1090088
     C                   ENDSR                                                             AR1090088
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Key lists
O
O    C     K_GZACCNTL1   KLIST
O    C                   KFLD                    CNUM
O    C                   KFLD                    CCY
O    C                   KFLD                    ACOD
O    C                   KFLD                    ACSQ
O    C                   KFLD                    BRCA

O    C     K_GZACCNTL2   KLIST
O    C                   KFLD                    BRCA
O    C                   KFLD                    CNUM
O    C                   KFLD                    CCY
O    C                   KFLD                    ACOD
O    C                   KFLD                    ACSQ

O    C     K_GZACODL1    KLIST
O    C                   KFLD                    I#ZONE
O    C                   KFLD                    ACCD             10

O    C     K_GZCUSGL1    KLIST
O    C**********         KFLD                    BRCA                                       MD026387
O    C                   KFLD                    G_BBBRCD                                   MD026387
O    C                   KFLD                    CNUM
                                                                                           AR1090088
O    C     K_GZBRCHL1    KLIST                                                             AR1090088
O    C                   KFLD                    I#ZONE                                    AR1090088
O    C                   KFLD                    G_BBBRCD                                  AR1090088

     C                   CALL      'GPCOPN4COM'                                             AR645170
     C                   PARM                    D_COM             1                        AR645170
     C                   OPEN      GPAMADL0                                                 AR645170
      *                                                                                     AR645170
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
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
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
** CmdArray
OVRDBF FILE(          ) SHARE(*NO)                                                           256612A
DLTOVR FILE(          )                                                                      256612A
