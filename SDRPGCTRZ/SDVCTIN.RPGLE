     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Country of TIN')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVCTIN - Validate Country of TIN                            *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL157             Date 17Aug15               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
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
      ** Country of TIN
     D***CtxArr*         S              2    DIM(5)                                           CGL157
     D CtxArr          S              2    DIM(10)                                            CGL157
 
      ** External DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1
     D DDTIN2          S             25
     D DDTIN3          S             25
     D DDTIN4          S             25
     D DDTIN5          S             25
     D DDTIN6          S             25                                                       CGL157
     D DDTIN7          S             25                                                       CGL157
     D DDTIN8          S             25                                                       CGL157
     D DDTIN9          S             25                                                       CGL157
     D DDTIN0          S             25                                                       CGL157
     D DDCOLC          S              2
     D DDCTIN2         S              2
     D DDCTIN3         S              2
     D DDCTIN4         S              2
     D DDCTIN5         S              2
     D DDCTIN6         S              2                                                       CGL157
     D DDCTIN7         S              2                                                       CGL157
     D DDCTIN8         S              2                                                       CGL157
     D DDCTIN9         S              2                                                       CGL157
     D DDCTIN0         S              2                                                       CGL157
     D DDOKCOLC        S              1
     D DDOKCTIN2       S              1
     D DDOKCTIN3       S              1
     D DDOKCTIN4       S              1
     D DDOKCTIN5       S              1
     D DDOKCTIN6       S              1                                                       CGL157
     D DDOKCTIN7       S              1                                                       CGL157
     D DDOKCTIN8       S              1                                                       CGL157
     D DDOKCTIN9       S              1                                                       CGL157
     D DDOKCTIN0       S              1                                                       CGL157
     D Z               S              3P 0
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S              2
 
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
     C                   EXSR      SRVCTIN
 
      ** If an error was found, set the return code appropriately
     C                   IF        DDOKCTIN2 = 'N' OR
     C                             DDOKCTIN3 = 'N' OR
     C                             DDOKCTIN4 = 'N' OR
     C                             DDOKCTIN5 = 'N' OR
     C                             DDOKCTIN6 = 'N' OR                                         CGL157
     C                             DDOKCTIN7 = 'N' OR                                         CGL157
     C                             DDOKCTIN8 = 'N' OR                                         CGL157
     C                             DDOKCTIN9 = 'N' OR                                         CGL157
     C                             DDOKCTIN0 = 'N' OR                                         CGL157
     C                             DDOKCOLC  = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCTIN - Validate Country of TIN                             *
      *                                                               *
      *****************************************************************
 
     C     SRVCTIN       BEGSR
 
      ** Up to 5 Country of TIN can be defined but without any gap
     C                   EVAL      CtxArr(1) = DDCOLC
     C                   EVAL      CtxArr(2) = DDCTIN2
     C                   EVAL      CtxArr(3) = DDCTIN3
     C                   EVAL      CtxArr(4) = DDCTIN4
     C                   EVAL      CtxArr(5) = DDCTIN5
     C                   EVAL      CtxArr(6) = DDCTIN6                                        CGL157
     C                   EVAL      CtxArr(7) = DDCTIN7                                        CGL157
     C                   EVAL      CtxArr(8) = DDCTIN8                                        CGL157
     C                   EVAL      CtxArr(9) = DDCTIN9                                        CGL157
     C                   EVAL      CtxArr(10) = DDCTIN0                                       CGL157
 
     C                   EVAL      Z = 1
     C     *BLANKS       LOOKUP    CtxArr(Z)                              28
 
     C                   IF        *IN28 = *ON
     C*****Z****         DOWLT     5                                                          CGL157
     C     Z             DOWLT     11                                                         CGL157
     C                   ADD       1             Z
     C                   IF        CtxArr(Z) <> *BLANKS
     C                   EVAL      DDOKCOLC = 'N'
     C                   EVAL      DDOKCTIN2 = 'N'
     C                   EVAL      DDOKCTIN3 = 'N'
     C                   EVAL      DDOKCTIN4 = 'N'
     C                   EVAL      DDOKCTIN5 = 'N'
     C                   EVAL      DDOKCTIN6 = 'N'                                            CGL157
     C                   EVAL      DDOKCTIN7 = 'N'                                            CGL157
     C                   EVAL      DDOKCTIN8 = 'N'                                            CGL157
     C                   EVAL      DDOKCTIN9 = 'N'                                            CGL157
     C                   EVAL      DDOKCTIN0 = 'N'                                            CGL157
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN2'     FldNamXAr(Idx)
     C                   MOVEL     'USS0288'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
 
      ** TINs and Countries of TIN are linked together.  Both must
      ** be populated or both must be blank.
     C                   IF        DDCTIN2 <> *BLANKS AND
     C                             DDTIN2 = *BLANKS
     C                   EVAL      DDOKCTIN2 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN2'     FldNamXAr(Idx)
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDCTIN3 <> *BLANKS AND
     C                             DDTIN3 = *BLANKS
     C                   EVAL      DDOKCTIN3 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN3'     FldNamXAr(Idx)
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDCTIN4 <> *BLANKS AND
     C                             DDTIN4 = *BLANKS
     C                   EVAL      DDOKCTIN4 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN4'     FldNamXAr(Idx)
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   IF        DDCTIN5 <> *BLANKS AND
     C                             DDTIN5 = *BLANKS
     C                   EVAL      DDOKCTIN5 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN5'     FldNamXAr(Idx)
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
                                                                                              CGL157
     C                   IF        DDCTIN6 <> *BLANKS AND                                     CGL157
     C                             DDTIN6 = *BLANKS                                           CGL157
     C                   EVAL      DDOKCTIN6 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN6'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN7 <> *BLANKS AND                                     CGL157
     C                             DDTIN7 = *BLANKS                                           CGL157
     C                   EVAL      DDOKCTIN7 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN7'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN8 <> *BLANKS AND                                     CGL157
     C                             DDTIN8 = *BLANKS                                           CGL157
     C                   EVAL      DDOKCTIN8 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN8'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN9 <> *BLANKS AND                                     CGL157
     C                             DDTIN9 = *BLANKS                                           CGL157
     C                   EVAL      DDOKCTIN9 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN9'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN0 <> *BLANKS AND                                     CGL157
     C                             DDTIN0 = *BLANKS                                           CGL157
     C                   EVAL      DDOKCTIN0 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN0'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0293'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
 
      ** Countries of TIN must be unique and a valid country code
     C                   IF        DDCOLC <> *BLANKS
     C                   EVAL      Z = 2
     C     DDCOLC        LOOKUP    CtxArr(Z)                              28
 
     C                   IF        *IN28 = *ON
     C                   EVAL      DDOKCOLC = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCOLC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0294'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDCTIN2 <> *BLANKS
     C                   EVAL      Z = 3
     C     DDCTIN2       LOOKUP    CtxArr(Z)                              28
 
     C                   IF        *IN28 = *ON
     C                   EVAL      DDOKCTIN2 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN2'     FldNamXAr(Idx)
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   EVAL      PKEY1 = DDCTIN2
     C                   EXSR      SRVCTRY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTIN2 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN2'     FldNamXAr(Idx)
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      DDCTIN2 = A4CNCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDCTIN3 <> *BLANKS
     C                   EVAL      Z = 4
     C     DDCTIN3       LOOKUP    CtxArr(Z)                              28
 
     C                   IF        *IN28 = *ON
     C                   EVAL      DDOKCTIN3 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN3'     FldNamXAr(Idx)
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   EVAL      PKEY1 = DDCTIN3
     C                   EXSR      SRVCTRY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTIN3 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN3'     FldNamXAr(Idx)
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      DDCTIN3 = A4CNCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDCTIN4 <> *BLANKS
     C                   EVAL      Z = 5
     C     DDCTIN4       LOOKUP    CtxArr(Z)                              28
 
     C                   IF        *IN28 = *ON
     C                   EVAL      DDOKCTIN4 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN4'     FldNamXAr(Idx)
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
     C                   EVAL      PKEY1 = DDCTIN4
     C                   EXSR      SRVCTRY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTIN4 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN4'     FldNamXAr(Idx)
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      DDCTIN4 = A4CNCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        DDCTIN5 <> *BLANKS
     C                   EVAL      Z = 6                                                      CGL157
     C     DDCTIN5       LOOKUP    CtxArr(Z)                              28                  CGL157
                                                                                              CGL157
     C                   IF        *IN28 = *ON                                                CGL157
     C                   EVAL      DDOKCTIN5 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN5'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157

     C                   EVAL      PKEY1 = DDCTIN5
     C                   EXSR      SRVCTRY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTIN5 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTIN5'     FldNamXAr(Idx)
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      DDCTIN5 = A4CNCD
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CGL157
     C                   IF        DDCTIN6 <> *BLANKS                                         CGL157
     C                   EVAL      Z = 7                                                      CGL157
     C     DDCTIN6       LOOKUP    CtxArr(Z)                              28                  CGL157
                                                                                              CGL157
     C                   IF        *IN28 = *ON                                                CGL157
     C                   EVAL      DDOKCTIN6 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN6'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      PKEY1 = DDCTIN6                                            CGL157
     C                   EXSR      SRVCTRY                                                    CGL157
                                                                                              CGL157
     C                   IF        PRTCD <> *Blanks                                           CGL157
     C                   EVAL      DDOKCTIN6 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN6'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCTIN6 = A4CNCD                                           CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN7 <> *BLANKS                                         CGL157
     C                   EVAL      Z = 8                                                      CGL157
     C     DDCTIN7       LOOKUP    CtxArr(Z)                              28                  CGL157
                                                                                              CGL157
     C                   IF        *IN28 = *ON                                                CGL157
     C                   EVAL      DDOKCTIN7 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN7'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      PKEY1 = DDCTIN7                                            CGL157
     C                   EXSR      SRVCTRY                                                    CGL157
                                                                                              CGL157
     C                   IF        PRTCD <> *Blanks                                           CGL157
     C                   EVAL      DDOKCTIN7 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN7'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCTIN7 = A4CNCD                                           CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN8 <> *BLANKS                                         CGL157
     C                   EVAL      Z = 9                                                      CGL157
     C     DDCTIN8       LOOKUP    CtxArr(Z)                              28                  CGL157
                                                                                              CGL157
     C                   IF        *IN28 = *ON                                                CGL157
     C                   EVAL      DDOKCTIN8 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN8'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      PKEY1 = DDCTIN8                                            CGL157
     C                   EXSR      SRVCTRY                                                    CGL157
                                                                                              CGL157
     C                   IF        PRTCD <> *Blanks                                           CGL157
     C                   EVAL      DDOKCTIN8 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN8'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCTIN8 = A4CNCD                                           CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN9 <> *BLANKS                                         CGL157
     C                   EVAL      Z = 10                                                     CGL157
     C     DDCTIN9       LOOKUP    CtxArr(Z)                              28                  CGL157
                                                                                              CGL157
     C                   IF        *IN28 = *ON                                                CGL157
     C                   EVAL      DDOKCTIN9 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN9'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0295'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      PKEY1 = DDCTIN9                                            CGL157
     C                   EXSR      SRVCTRY                                                    CGL157
                                                                                              CGL157
     C                   IF        PRTCD <> *Blanks                                           CGL157
     C                   EVAL      DDOKCTIN9 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN9'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCTIN9 = A4CNCD                                           CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        DDCTIN0 <> *BLANKS                                         CGL157
                                                                                              CGL157
     C                   EVAL      PKEY1 = DDCTIN0                                            CGL157
     C                   EXSR      SRVCTRY                                                    CGL157
                                                                                              CGL157
     C                   IF        PRTCD <> *Blanks                                           CGL157
     C                   EVAL      DDOKCTIN0 = 'N'                                            CGL157
     C                   ADD       1             Idx                                          CGL157
     C                   MOVEL     'DDCTIN0'     FldNamXAr(Idx)                               CGL157
     C                   MOVEL     'USS0296'     MsgIDXAr(Idx)                                CGL157
     C                   GOTO      ENDVAL                                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCTIN0 = A4CNCD                                           CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDIF                                                                CGL157
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCTRY - Validate Country Code                               *
      *                                                               *
      *****************************************************************
 
     C     SRVCTRY       BEGSR
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PKEY1
     C     SDCTRY        PARM      SDCTRY        DSSDY
 
     C                   ENDSR
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
      ** TIN2
     C                   PARM                    DDTIN2
      ** TIN3
     C                   PARM                    DDTIN3
      ** TIN4
     C                   PARM                    DDTIN4
      ** TIN5
     C                   PARM                    DDTIN5
                                                                                              CGL157
     C                   PARM                    DDTIN6                                       CGL157
      ** TIN3                                                                                 CGL157
     C                   PARM                    DDTIN7                                       CGL157
      ** TIN4                                                                                 CGL157
     C                   PARM                    DDTIN8                                       CGL157
      ** TIN5                                                                                 CGL157
     C                   PARM                    DDTIN9                                       CGL157
      ** TIN5                                                                                 CGL157
     C                   PARM                    DDTIN0                                       CGL157
      ** Country of Domicile
     C                   PARM                    DDCOLC
      ** Country of TIN 2
     C                   PARM                    DDCTIN2
      ** Country of TIN 3
     C                   PARM                    DDCTIN3
      ** Country of TIN 4
     C                   PARM                    DDCTIN4
      ** Country of TIN 5
     C                   PARM                    DDCTIN5
      ** Country of TIN 2                                                                     CGL157
     C                   PARM                    DDCTIN6                                      CGL157
      ** Country of TIN 3                                                                     CGL157
     C                   PARM                    DDCTIN7                                      CGL157
      ** Country of TIN 4                                                                     CGL157
     C                   PARM                    DDCTIN8                                      CGL157
      ** Country of TIN 5                                                                     CGL157
     C                   PARM                    DDCTIN9                                      CGL157
      ** Country of TIN 5                                                                     CGL157
     C                   PARM                    DDCTIN0                                      CGL157
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Country of Domicile - OK
     C                   PARM                    DDOKCOLC
      ** Country of TIN 2 - OK
     C                   PARM                    DDOKCTIN2
      ** Country of TIN 3 - OK
     C                   PARM                    DDOKCTIN3
      ** Country of TIN 4 - OK
     C                   PARM                    DDOKCTIN4
      ** Country of TIN 5 - OK
     C                   PARM                    DDOKCTIN5
      ** Country of TIN 2 - OK                                                                CGL157
     C                   PARM                    DDOKCTIN6                                    CGL157
      ** Country of TIN 3 - OK                                                                CGL157
     C                   PARM                    DDOKCTIN7                                    CGL157
      ** Country of TIN 4 - OK                                                                CGL157
     C                   PARM                    DDOKCTIN8                                    CGL157
      ** Country of TIN 5 - OK                                                                CGL157
     C                   PARM                    DDOKCTIN9                                    CGL157
      ** Country of TIN 5 - OK                                                                CGL157
     C                   PARM                    DDOKCTIN0                                    CGL157
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
(c) Finastra International Limited 2013
