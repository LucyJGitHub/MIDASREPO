     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Generated Code Amended for TS processing ACCNTBXC')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO011001 - Bulk Update of Global File GZACCNTBXC             *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 CGP017  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *                                                               *
      *****************************************************************
     FACCNTBXC  IF   E             DISK    RECNO(WkRrn)
     F                                     INFSR(*PSSR)
     FACBXDVPD  IF   E           K DISK
     F                                     INFSR(*PSSR)

     D Z_ACCNTBXC    E DS                  EXTNAME(ACCNTBXC)
     D G_ACCNTBXC    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(G_)

     D WRun            S              1
     D WkRrn           S              9  0

      ** Main Process

     C                   Z-ADD     0             WkRrn
     C                   READ      ACBXDVPD
     C     GLFERN        SETLL     ACCNTBXC
     C                   READ      ACCNTBXC

     C                   DOW       NOT %EOF(ACCNTBXC) AND WkRrn <= GLTERN
     C                   EVAL      G_ACCNTBXC = Z_ACCNTBXC
B    C                   EVAL      G_ATBRCA = ATBRCA
     C                   EVAL      I#BFAF = 'A'
     C                   EXSR      UPGLBF
     C                   READ      ACCNTBXC
     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPGLBF - Update Global File                                  *
      *                                                               *
      *****************************************************************
     C     UPGLBF        BEGSR
     C                   EVAL      I#ZONE = I_ZONE
     C                   EVAL      I#TRAP = 'N'
     C                   EVAL      I#BIMG = G_ACCNTBXC
     C                   EVAL      I#AIMG = G_ACCNTBXC
     C/COPY GPCPYSRCG,GPACCNTBXC
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    I_ZONE           10

     C                   MOVEL     *BLANK        I#ERMS           50
     C                   CLEAR                   Z_ACCNTBXC
     C                   CLEAR                   G_ACCNTBXC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
