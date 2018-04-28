     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Main to Support System Control Menu')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC004302 - 'Main' to 'Support' System Control Menu           *
      *                                                               *
      *  Function:  This module will display the "Main' to 'Support'  *
      *             Control Menu.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    15         Nondisplay for Halt                             *
      *    16         Nondisplay for Continue                         *
      *    17         Error indicator for selection field             *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SREROR - Send Error Message                                  *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
     FSC004302DFCF   E             WORKSTN INFSR(*PSSR)
      ** Display file
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Main to Support System Transition Status Dataarea
     D SCMAIN        E DS                  EXTNAME(SCMAIN) DTAARA(SCMAIN)
 
      ** Bank Details ICD File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Dummy Data Structure used by Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PMsgId          S              7A
     D PMsgFile        S             10
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
     D WValid          S              1A
     D @RUN            S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   IN        SCMAIN
 
     C                   DOU       (#0SELC = '4') OR (#0SELC = '1')
     C                             AND (S2PHAS <> 'O')
 
      ** When S2STAT is equal to 'C'
 
     C                   IF        S2STAT = 'C'
     C                   EVAL      *IN15 = '1'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
 
      ** When S2STAT is not equal to 'C' but equal to 'H'
 
     C                   IF        S2STAT = 'H'
     C                   EVAL      *IN15 = '1'
     C                   EVAL      *IN16 = '0'
 
      ** When S2STAT is not equal to 'C' and not equal to 'H'
 
     C                   ELSE
     C                   EVAL      *IN15 = '0'
     C                   EVAL      *IN16 = '1'
     C                   ENDIF
     C                   ENDIF
 
     C                   WRITE     SC004302C0
     C                   EXFMT     SC004302F0
     C                   CALL      'ZA0250'
 
      ** Check if values are valid
 
     C                   IN        SCMAIN
     C                   EVAL      *IN17 = '0'
 
     C                   IF        (#0SELC <> '1') AND (#0SELC <> '2')
     C                             AND (#0SELC <> '3') AND (#0SELC <> '4')
     C                   EVAL      *IN17 = '1'
     C                   EVAL      PMsgId = 'SCC0002'
     C                   EXSR      SREROR
     C                   ELSE
     C
     C                   IF        S2STAT = 'H'
 
     C                   IF        #0SELC = '2'
     C                   EVAL      *IN17 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PMsgId = 'SCC0003'
     C                   EXSR      SREROR
     C                   ENDIF
 
     C                   ELSE
     C                   IF        #0SELC = '3'
     C                   EVAL      *IN17 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PMsgId = 'SCC0003'
     C                   EXSR      SREROR
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        (S2PHAS = 'O') AND (#0SELC = '1')
     C                   EVAL      *IN17 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PMsgId = 'SCC0004'
     C                   EXSR      SREROR
     C                   ENDIF
 
     C                   IF        (S2PHAS = 'O') AND (#0SELC = '2')
     C                   EVAL      *IN17 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PMsgId = 'SCC0005'
     C                   EXSR      SREROR
     C                   ENDIF
 
     C                   IF        (WValid <> 'N')
     C     *LOCK         IN        SCMAIN
     C                   SELECT
     C                   WHEN      #0SELC = '1'
     C                   EVAL      S2STAT = 'C'
     C                   WHEN      #0SELC = '2'
     C                   EVAL      S2STAT = 'H'
     C                   EVAL      #0SELC = *Blanks
     C                   WHEN      #0SELC = '3'
     C                   EVAL      S2STAT = *Blanks
     C                   EVAL      #0SELC = *Blanks
     C                   ENDSL
     C                   OUT       SCMAIN
     C                   ENDIF
 
     C                   EVAL      *IN15 = '0'
     C                   EVAL      *IN16 = '0'
     C                   EVAL      WValid = *Blanks
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
 
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
 
      ** Initialise all screen fields, indicators and function keys.
 
     C                   CALL      'ZA0250'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EVAL      #0SELC = *Blanks
     C                   EVAL      #0PGMQ = PSProcName
     C                   EVAL      *IN15 = '0'
     C                   EVAL      *IN16 = '0'
     C                   EVAL      *IN17 = '0'
     C                   EVAL      WValid = *Blanks
 
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 001
     C                   EVAL      DBfile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'SC004302'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0RUNA = BJMRDT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREROR - Send Error Message                                  *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: AOCREPT                                                *
      *                                                               *
      *****************************************************************
 
     C     SREROR        BEGSR
 
     C                   CALLB     'AOCREPT'
     C                   PARM                    PMsgId
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
