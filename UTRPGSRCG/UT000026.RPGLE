     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*XBI *  CRTSRCPF FILE(QTEMP/INPSRC) RCDLEN(112)                      *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Set up creation parameter strings')           *
/*XAI *  DLTF FILE(QTEMP/INPSRC)                                      *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000026 - Group creation parameters from file (W+job number)*
      *             into strings CrtPrm, XBCrtPrm, XACrtPrm           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT008  *CREATE    Date 20Dec10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT008 - Rewrite of CRTOBJ.                                  *
      *                                                               *
      *****************************************************************
     FINPSRC    IF   F  112        DISK
      *
     D PCrtPrm         S            948
     D PXBCrtPrm       S           7000
     D PXACrtPrm       S           7000
     D PCrtPrmLen      S              3  0
      *
     D XAStrPos        S              5  0 INZ(1)
     D XBStrPos        S              5  0 INZ(1)
     D PrevType        S              2    INZ(*blank)
      *
     D Recursive       S              1    INZ(*blank)
      *
     IINPSRC    NS  01
     I                                  1    6 2SRCSEQ
     I                                  7   12 0SRCDAT
     I                                 13  112  SRCDTA
     I                                 14   17  ParmType
     I                                 22   80  CrtPrmDta
     I                                 14   80  XAPrmDta
     I                                 14   80  XBPrmDta
      *
     C     *ENTRY        PLIST
     C                   PARM                    PCrtPrm                        Out
     C                   PARM                    PXBCrtPrm                      Out
     C                   PARM                    PXACrtPrm                      Out
     C                   PARM                    PCrtPrmLen                     Out
      *
     C     1             SETLL     INPSRC
     C                   READ      INPSRC
      *
     C                   DOW       Not %EOF
      *
     C                   SELECT
      *
     C                   WHEN      ParmType = '*CRT' OR
     C                             ParmType = '*EXI'
     C                   EXSR      AddCrtPrm
      *
     C                   WHEN      ParmType = '*XBI' OR
     C                             ParmType = '*OVR' OR
     C                             (PrevType = 'XB'  AND
     C                             ParmType = '*END')
     C                   EXSR      AddXBPrm
      *
     C                   WHEN      ParmType = '*XAI' OR
     C                             ParmType = '*ADD' OR
     C                             (PrevType = 'XA'  AND
     C                             ParmType = '*END')
     C                   EXSR      AddXAPrm
      *
     C                   OTHER
     C                   ENDSL
      *
     C                   READ      INPSRC
     C                   ENDDO                                                  DOW Not %EOF
      *
     C                   EVAL      PCrtPrmLen = %Len(%Trim(PCrtPrm))
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  AddCrtPrm - Add the *CRT parameters to field PCrtPrm         *
      *                                                               *
      *****************************************************************
      *
     C     AddCrtPrm     BEGSR
      *
     C                   EVAL      PCrtPrm = %Trim(PCrtPrm) + ' '
     C                                       + CrtPrmDta
     C                   EVAL      PrevType = *blank
      *
     C     AddCrtPrmE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AddXBParm - Add the *XB parameters to field PXBCrtPrm        *
      *                                                               *
      *****************************************************************
      *
     C     AddXBPrm      BEGSR
      *
     C                   EVAL      PXBCrtPrm = %Replace(XBPrmDta: PXBCrtPrm:
     C                                           XBStrPos)
     C                   EVAL      XBStrPos = XBStrPos + 70
      *
     C                   IF        ParmType = '*END'
     C                   EVAL      PrevType = *blank
     C                   ELSE
     C                   EVAL      PrevType = 'XB'
     C                   ENDIF
      *
     C     AddXBPrmE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AddXAParm - Add the *XA parameters to field PXACrtPrm        *
      *                                                               *
      *****************************************************************
      *
     C     AddXAPrm      BEGSR
      *
     C                   EVAL      PXACrtPrm = %Replace(XAPrmDta: PXACrtPrm:
     C                                           XAStrPos)
     C                   EVAL      XAStrPos = XAStrPos + 70
      *
     C                   IF        ParmType = '*END'
     C                   EVAL      PrevType = *blank
     C                   ELSE
     C                   EVAL      PrevType = 'XA'
     C                   ENDIF
      *
     C     AddXAPrmE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
