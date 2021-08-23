     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************             LUC109
/*STD *  RPGBASEBND                                                   *             LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***DLM010*-*Remove*Dealing*Events*on*Rerun***********************             LUC109
      *  XXSL0010 - Midas HOR Remove Dealing events on Re-run         *             LUC109
      *****************************************************************
      * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
      * OF LIBL ***                                                   *
      *****************************************************************
      *                                                               *
      *  Function: To remove records added to the HOR Dealing History *
      *************File*in*earlier*rus*of*the*GLCM048*extract.        *             LUC109
      *            File in earlier runs of XXC000048 extract.         *             LUC109
      *                                                               *
      ***Called*By:*GLCM048*-*HOR*Extract******************************             LUC109
      *  Called By: XXC000048 - HOR Extract                           *             LUC109
      *                                                               *
      ***(c)*Misys*2004************************************************             LUC109
      *  (c) Finastra International Limited 2016                      *             LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 16Sep16               *
      *  Prev Amend No. MUI011  *CREATE    Date 07Jun04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FBM 2.1)                   *
      *  MUI011 - ALMS changes to HOR                                 *
      *                                                               *
      *****************************************************************
      *
     FSDGELRPP  IF   E             DISK
     FDLMPEVPP  UF   E             DISK
      *
      * Read HOR ICD for today's date
      *
     C     1             SETLL     SDGELRPP
     C                   READ      SDGELRPP                               01
      *
      * Remove all records entered today
      *
     C                   READ      DLMPEVPP                               01
      *
     C     *IN01         DOWEQ     *OFF
     C     HORED         IFEQ      MLACD
     C                   DELETE    DLMPEVP0
     C                   ENDIF
     C                   READ      DLMPEVPP                               01
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
