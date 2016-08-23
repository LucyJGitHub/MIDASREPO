     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP History of Customer Info Field Desc')         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP2014001 - Midas GP History of Customer Info Field Desc     *
      *                                                               *
      *  Function: This module create file fields description         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD026854           Date 29May14               *
      *  Prev Amend No. MD026666           Date 22May14               *
      *                 CGL132             Date 01May13               *
      *                 MD026193           Date 07Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD026666 - Incorrect details reflected in history of         *
      *             customer information                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD026193 - History of cust information is not updated        *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
     FGPFLDDSPD O    E             DISK
 
     D  PFieldsDesc    DS
     D  PFieldName                   10A   dim( FieldArrSize )
     D  PFieldPosn                   10I 0 dim( FieldArrSize )
     D  PFieldLen                    10I 0 dim( FieldArrSize )
     D  PFieldDigt                   10I 0 dim( FieldArrSize )
     D  PFieldType                    1A   dim( FieldArrSize )
     D  PFieldText                   30A   dim( FieldArrSize )
     D  FieldArrSize   C                   1200
 
     D PFileNames      DS
     D  FileNameArr                  10A   dim(FileArrSize)
     D  FileArrSize    C                   10
     D PFieldsNum      S              5I 0
     D PFileName       S             10A
     D Idx             S              5I 0
     D Index           S              5I 0
     D Prtcd           S              7A
     D Wpos            S              5S 0                                                  MD026666
 
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRRtvFldDtl
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvFldDtl - Retrieve detailed fields description           *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : UTRTVFLDD                                         *
      *                                                               *
      *****************************************************************
     C     SRRtvFldDtl   BEGSR
 
     C                   EVAL      PFileNames = *BLANKS
     C                   EVAL      FileNameArr(1) = 'SDCUSTPD'
     C                   EVAL      FileNameArr(2) = 'SDACUSPD'
     C                   EVAL      FileNameArr(3) = 'SDFTCSPD'                                CGL132
     C                   EVAL      FileNameArr(4) = 'SDJACCPD'                                CGL132
     C                   EVAL      FileNameArr(5) = 'SDCUAHPD'                                CGL132
     C                   EVAL      FileNameArr(6) = 'SDCUSTXC'                              MD026854
     C**********         EVAL      FileNameArr(3) = 'SDJACCPD'                       MD026193 CGL132
     C**********         EVAL      FileNameArr(4) = 'SDCUAHPD'                       MD026193 CGL132
     C**********         EVAL      FileNameArr(3) = 'SDFTCSPD'                              MD026193
     C**********         EVAL      FileNameArr(4) = 'SDJACCPD'                              MD026193
     C**********         EVAL      FileNameArr(5) = 'SDCUAHPD'                              MD026193
     C                   EVAL      Index = 1
 
     C                   DOW       FileNameArr (Index) <> *BLANKS and
     C                             FileArrSize > Index
 
     C                   EVAL      PFileName = FileNameArr(Index)
 
     C**********         CALL      'UTRTVFLDD'                                                CGL132
     C                   CALL      'UTRTVFLDD'                          55                    CGL132
     C                   PARM      *BLANKS       Prtcd
     C                   PARM                    PFileName
     C                   PARM      *BLANKS       PFieldsDesc
     C                   PARM      *ZEROS        PFieldsNum
 
     C                   IF        Prtcd = *BLANKS
 
     C                   EVAL      Idx = 0
     C                   EVAL      WPos = 0                                                 MD026666
     C                   DO        PFieldsNum
     C                   EXSR      SRUpdateDtl
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      Index = Index + 1
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdateDtl - Create detailed fields description             *
      *                                                               *
      *  Called by: SRRtvFldDtl                                       *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRUpdateDtl   BEGSR
 
     C                   EVAL      Idx = Idx + 1
 
     C                   EVAL      GPFILN   = PFileName
     C                   EVAL      GPFILS   = Index
     C                   EVAL      GPFLDN   = PFieldName (Idx)
     C**********         EVAL      GPFPOS   = PFieldPosn (Idx)                              MD026666
     C                   EVAL      GPFPOS   = PFieldPosn (Idx) + WPos                       MD026666
                                                                                            MD026666
     C                   IF        PFieldType (Idx) = 'P'                                   MD026666
     C                   EVAL      GPFLDL   = PFieldDigt (Idx)                              MD026666
     C                   EVAL      WPos = Wpos + PFieldDigt (Idx)                           MD026666
     C                                  - PFieldLen (Idx)                                   MD026666
     C                   ELSE                                                               MD026666
     C                   EVAL      GPFLDL   = PFieldLen  (Idx)
     C                   ENDIF                                                              MD026666
                                                                                            MD026666
     C                   EVAL      GPFLDD   = PFieldDigt (Idx)
     C                   EVAL      GPFLDT   = PFieldType (Idx)
     C                   EVAL      GPFTXT   = PFieldText (Idx)
     C                   WRITE     GPFLDDSG0
 
     C                   ENDSR
      *****************************************************************
