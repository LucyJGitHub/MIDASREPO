     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access to Retail Acct Balance Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAORABER0 - Midas GP Access to Retail Acct Balance Extract  *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27878           Date 06Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27288 *CREATE   Date 07Apr10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27878 - Projected Available Balance Enquiry(recompile)    *
      *  BUG27288 - A serios Midas error has occured message comes    *
      *             up when completing insert for Batch Details       *
      *             in GL - JRNE                                      *
      *                                                               *
      *****************************************************************
 
      ** GP Retail Account Balance Extracts by Account Identifier
 
     FGPRABEL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** GP Retail Account Balance Extracts by Currency
 
     FGPRABEL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPRABED0:GPRABED2)
     F                                     USROPN
 
      ** GP Retail Account Balance Extracts by Customer
 
     FGPRABEL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPRABED0:GPRABED3)
     F                                     USROPN
 
      ** GP Retail Account Balance Extracts by Facility
 
     FGPRABEL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPRABED0:GPRABED4)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Short Data Structure for Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Retail Account Balance Extracts Data Structure
 
     D GPRABE        E DS                  EXTNAME(GPRABEPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1
     D WOpen           S              1
 
      ** Parameters
 
     D I#RtnCode       S              7A
     D I#Option        S              7A
     D I#SubRtn        S             10A
     D I#BRCA          S              3A
     D I#CNUM          S              6A
     D I#CCY           S              3A
     D I#ACOD          S             10S 0
     D I#ACSQ          S              2S 0
     D I#FACT          S              3S 0
     D I#FCNO          S              2S 0
     D O#OutputImage   S                   LIKE(GPRABE)
 
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SrInit
     C                   EXSR      SrProcess
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Clear return code
 
     C                   EVAL      I#RtnCode     = *BLANKS
     C                   EVAL      O#OutputImage = *BLANKS
 
      ** Open file once
 
     C                   IF        WOpen <> 'Y'
     C                   OPEN      GPRABEL0
     C                   OPEN      GPRABEL2
     C                   OPEN      GPRABEL3
     C                   OPEN      GPRABEL4
     C                   EVAL      WOpen = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess - Main Processing Subroutine                       *
      *                                                               *
      *****************************************************************
 
     C     SrProcess     BEGSR
 
     C                   SELECT
     C                   WHEN      I#SubRtn = 'SrACCNT' OR
     C                             I#SubRtn = 'SrMEMOS' OR
     C                             I#SubRtn = 'SrGLACN'
     C                   EXSR      SrChain
     C                   WHEN      I#SubRtn = 'SrSDCUR'
     C                   EXSR      SrCurr
     C                   WHEN      I#SubRtn = 'SrSDCUS'
     C                   EXSR      SrCust
     C                   WHEN      I#SubRtn = 'SrSDBRC'
     C                   EXSR      SrBrca
     C                   WHEN      I#SubRtn = 'SrFCLTY'
     C                   EXSR      SrFclt
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChain - Chain Account Record from GPRABEL0                 *
      *                                                               *
      *****************************************************************
 
     C     SrChain       BEGSR
 
     C     K_Accnt       CHAIN     GPRABEL0
 
     C                   IF        %FOUND(GPRABEL0)
     C                   EVAL      O#OutputImage = GPRABE
     C                   ELSE
     C                   EVAL      I#RtnCode = '*NOREC'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCurr - Read records from GPRABEL2 based on currency        *
      *                                                               *
      *****************************************************************
 
     C     SrCurr        BEGSR
 
      ** Reset file pointer if first record is requested
 
     C                   IF        I#Option = '*FIRST '
     C     I#CCY         SETLL     GPRABEL2
     C                   EVAL      I#Option = '*NEXT  '
     C                   ENDIF
 
      ** Read sequentially if next record is requested
 
     C                   IF        I#Option = '*NEXT  '
     C     I#CCY         READE     GPRABEL2
 
     C                   IF        %EOF(GPRABEL2)
     C                   EVAL      I#RtnCode = '*EOF'
     C                   ELSE
     C                   EVAL      O#OutputImage = GPRABE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCust - Read records from GPRABEL4 based on customer        *
      *                                                               *
      *****************************************************************
 
     C     SrCust        BEGSR
 
      ** Reset file pointer if first record is requested
 
     C                   IF        I#Option = '*FIRST '
     C     I#CNUM        SETLL     GPRABEL4
     C                   EVAL      I#Option = '*NEXT  '
     C                   ENDIF
 
      ** Read sequentially if next record is requested
 
     C                   IF        I#Option = '*NEXT  '
     C     I#CNUM        READE     GPRABEL4
 
     C                   IF        %EOF(GPRABEL4)
     C                   EVAL      I#RtnCode = '*EOF'
     C                   ELSE
     C                   EVAL      O#OutputImage = GPRABE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBrca - Read records from GPRABEL0 based on branch          *
      *                                                               *
      *****************************************************************
 
     C     SrBrca        BEGSR
 
      ** Reset file pointer if first record is requested
 
     C                   IF        I#Option = '*FIRST '
     C     I#BRCA        SETLL     GPRABEL0
     C                   EVAL      I#Option = '*NEXT  '
     C                   ENDIF
 
      ** Read sequentially if next record is requested
 
     C                   IF        I#Option = '*NEXT  '
     C     I#BRCA        READE     GPRABEL0
 
     C                   IF        %EOF(GPRABEL0)
     C                   EVAL      I#RtnCode = '*EOF'
     C                   ELSE
     C                   EVAL      O#OutputImage = GPRABE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFclt - Chain records from GPRABEL3 based on facility       *
      *           details                                             *
      *                                                               *
      *****************************************************************
 
     C     SrFclt        BEGSR
 
      ** Reset file pointer if first record is requested
 
     C                   IF        I#Option = '*FIRST '
     C     K_Fclty       SETLL     GPRABEL3
     C                   EVAL      I#Option = '*NEXT  '
     C                   ENDIF
 
      ** Read sequentially if next record is requested
 
     C                   IF        I#Option = '*NEXT  '
     C     K_Fclty       READE     GPRABEL3
 
     C                   IF        %EOF(GPRABEL3)
     C                   EVAL      I#RtnCode = '*EOF'
     C                   ELSE
     C                   EVAL      O#OutputImage = GPRABE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine called automatically at program   *
      *          start                                                *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RtnCode
     C                   PARM                    I#Option
     C                   PARM                    I#SubRtn
     C                   PARM                    I#BRCA
     C                   PARM                    I#CNUM
     C                   PARM                    I#CCY
     C                   PARM                    I#ACOD
     C                   PARM                    I#ACSQ
     C                   PARM                    I#FACT
     C                   PARM                    I#FCNO
     C                   PARM                    O#OutputImage
 
      ** Key lists
 
     C     K_Accnt       KLIST
     C                   KFLD                    I#BRCA
     C                   KFLD                    I#CNUM
     C                   KFLD                    I#CCY
     C                   KFLD                    I#ACOD
     C                   KFLD                    I#ACSQ
 
     C     K_Fclty       KLIST
     C                   KFLD                    I#CNUM
     C                   KFLD                    I#FACT
     C                   KFLD                    I#FCNO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  --- Abnormal Error Conditions                          *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     WRun          IFEQ      *BLANKS
 
     C                   MOVE      'Y'           WRun
 
      ** If no identified cause of error
 
     C     I#RtnCode     IFEQ      *BLANK
     C                   EVAL      I#RtnCode = '*ERROR'
     C                   ENDIF
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
 
     C                   DUMP
 
     C                   CLOSE     GPRABEL0
     C                   CLOSE     GPRABEL2
     C                   CLOSE     GPRABEL3
     C                   CLOSE     GPRABEL4
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
