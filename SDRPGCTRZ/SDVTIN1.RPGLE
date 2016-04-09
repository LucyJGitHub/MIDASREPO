     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate TIN')                                *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVTIN1 - Validate TIN                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** TINs
     D TINArr          S             25    DIM(5)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D DDTINO          S             25
     D DDTIN2          S             25
     D DDTIN3          S             25
     D DDTIN4          S             25
     D DDTIN5          S             25
     D DDCTIN2         S              2
     D DDCTIN3         S              2
     D DDCTIN4         S              2
     D DDCTIN5         S              2
     D DDOKTINO        S              1
     D DDOKTIN2        S              1
     D DDOKTIN3        S              1
     D DDOKTIN4        S              1
     D DDOKTIN5        S              1
     D Z               S              3P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialization
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0
 
      ** Validation
     C                   EXSR      SRVTIN
 
      ** If an error was found, set the return code appropriately
     C                   IF        DDOKTIN2 = 'N' OR
     C                             DDOKTIN3 = 'N' OR
     C                             DDOKTIN4 = 'N' OR
     C                             DDOKTIN5 = 'N' OR
     C                             DDOKTINO = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVTIN - Validate TIN                                         *
      *                                                               *
      *****************************************************************
 
     C     SRVTIN        BEGSR
 
      ** Up to 5 TINs can be defined but without any gap
     C                   EVAL      TINArr(1) = DDTINO
     C                   EVAL      TINArr(2) = DDTIN2
     C                   EVAL      TINArr(3) = DDTIN3
     C                   EVAL      TINArr(4) = DDTIN4
     C                   EVAL      TINArr(5) = DDTIN5
 
     C                   EVAL      Z = 1
     C     *BLANKS       LOOKUP    TINArr(Z)                              28
 
     C                   IF        *IN28 = *ON
     C     Z             DOWLT     5
     C                   ADD       1             Z
     C                   IF        TINArr(Z) <> *BLANKS
     C                   EVAL      DDOKTINO = 'N'
     C                   EVAL      DDOKTIN2 = 'N'
     C                   EVAL      DDOKTIN3 = 'N'
     C                   EVAL      DDOKTIN4 = 'N'
     C                   EVAL      DDOKTIN5 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTIN2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0287'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** TINs and Countries of TIN are linked together.  Both must
      ** be populated or both must be blank.
     C                   IF        DDTIN2 <> *BLANKS AND
     C                             DDCTIN2 = *BLANKS
     C                   EVAL      DDOKTIN2 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTIN2'      FldNamXAr(Idx)
     C                   MOVEL     'USS0291'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDTIN3 <> *BLANKS AND
     C                             DDCTIN3 = *BLANKS
     C                   EVAL      DDOKTIN3 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTIN3'      FldNamXAr(Idx)
     C                   MOVEL     'USS0291'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDTIN4 <> *BLANKS AND
     C                             DDCTIN4 = *BLANKS
     C                   EVAL      DDOKTIN4 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTIN4'      FldNamXAr(Idx)
     C                   MOVEL     'USS0291'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDTIN5 <> *BLANKS AND
     C                             DDCTIN5 = *BLANKS
     C                   EVAL      DDOKTIN5 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTIN5'      FldNamXAr(Idx)
     C                   MOVEL     'USS0291'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** TIN
     C                   PARM                    DDTINO
      ** TIN2
     C                   PARM                    DDTIN2
      ** TIN3
     C                   PARM                    DDTIN3
      ** TIN4
     C                   PARM                    DDTIN4
      ** TIN5
     C                   PARM                    DDTIN5
      ** Country of TIN 2
     C                   PARM                    DDCTIN2
      ** Country of TIN 3
     C                   PARM                    DDCTIN3
      ** Country of TIN 4
     C                   PARM                    DDCTIN4
      ** Country of TIN 5
     C                   PARM                    DDCTIN5
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** TIN - OK
     C                   PARM                    DDOKTINO
      ** TIN 2 - OK
     C                   PARM                    DDOKTIN2
      ** TIN 3 - OK
     C                   PARM                    DDOKTIN3
      ** TIN 4 - OK
     C                   PARM                    DDOKTIN4
      ** TIN 5 - OK
     C                   PARM                    DDOKTIN5
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *Blanks
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2013
