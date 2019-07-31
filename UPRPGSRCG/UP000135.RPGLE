     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UPALLSPD) TOFILE(QADSPOBJ)                        *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Load module, pgm, service pgm src file')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000135 - Load module and program source file               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Called By: UPC000135                                         *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK022             Date 29Jul05               *
      *                 CUP029 *C *CREATE  Date 22Sep04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK022 - Should not use zone /COPYs.                         *
      *  CUP029 - Utility to cross check module and program sources   *
      *           in a library.                                       *
      *                                                               *
      *****************************************************************
      * Function of indicators                                        *
      *                                                               *
      *       20      End of file                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FUPALLSPD  IF   E             DISK    INFSR(*PSSR)
      * RTV : Midsa UP All source files in a library (temporary)
      *
     FUPSRCFPD  O    E             DISK    INFSR(*PSSR)
      * WRT : Midsa UP Module, program and service pgm sources
      *
      /EJECT
      *****************************************************************
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D***/COPY*ZACPYSRC,PSDS*                                                                 CPK022
     D/COPY GPCPYSRCG,PSDS                                                                    CPK022
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Data structure for object name
     D                 DS
     D  ODOBNM                 1     10
     D  SrcPrefix              1      2
     D  SrcName                3     10
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *                                                               *
      * Calls: GetGobalSrc                                            *
      *        GetZoneSrc                                             *
      *        GetNoLayerSrc                                          *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    Layer             7
      *
      * Read DSPOBJD output file
     C                   READ      UPALLSPD                               20    EOF
      *
     C                   DOW       *IN20 = '0'
      *
      * Select physical file only and not skeleton source
     C                   IF        ODOBAT = 'PF' AND
     C                             SrcPrefix <> 'SK'
      *
     C     Layer         CASEQ     '*GLOBAL'     GetGlobalSrc
     C     Layer         CASEQ     '*ZONE  '     GetZoneSrc
     C     Layer         CASEQ     '*NONE  '     GetNoLayerSrc
     C                   ENDCS
      *
     C                   ENDIF                                                  FI *DOBAT = 'PF'
      *                                                                         and SrcPrefix<>SK
      *
     C                   READ      UPALLSPD                               20
      *
     C                   ENDDO                                                  OD *IN20 = '0'
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * GetGlobalSrc - Identity global layer object and output to     *
      *                UPSRCFPD.                                      *
      *                                                               *
      * Called by:     Main processing                                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     GetGlobalSrc  BEGSR
      *
     C                   SELECT
 
     C                   WHEN      SrcName = 'RPGSRCG '  OR
     C                             SrcName = 'RPGCTRG '  OR
     C                             SrcName = 'CLPSRCG '  OR
     C                             SrcName = 'CLPCTRG '
     C                   EVAL      SRTYPE  = 'M'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   WHEN      SrcName = 'PGMSRCG '
     C                   EVAL      SRTYPE  = 'P'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   When      SrcName = 'SVPSRCG '
     C                   EVAL      SRTYPE  = 'S'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   ENDSL
      *
     C     GetGlobalSrcE ENDSR
      *
      *****************************************************************
      *                                                               *
      * GetZoneSrc   - Identity zone layer object and output to       *
      *                UPSRCSPD.                                      *
      *                                                               *
      * Called by:     Main processing                                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     GetZoneSRc    BEGSR
      *
     C                   SELECT
 
     C                   WHEN      SrcName = 'RPGSRCZ '  OR
     C                             SrcName = 'RPGCTRZ '  OR
     C                             SrcName = 'CLPSRCZ '  OR
     C                             SrcName = 'CLPCTRZ '
     C                   EVAL      SRTYPE  = 'M'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   WHEN      SrcName = 'PGMSRCZ '
     C                   EVAL      SRTYPE  = 'P'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   When      SrcName = 'SVPSRCZ '
     C                   EVAL      SRTYPE  = 'S'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   ENDSL
      *
     C     GetZoneSrcE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * GetNoLayerSrc - Identity valid objects (not ending with 'G' or*
      *                 'Z' and output to UPSRCFPD.                   *
      *                                                               *
      * Called by:     Main processing                                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     GetNoLayerSrc BEGSR
      *
     C                   SELECT
 
     C                   WHEN      SrcName = 'RPGSRC  '  OR
     C                             SrcName = 'RPGCTR  '  OR
     C                             SrcName = 'CLSRC   '  OR
     C                             SrcName = 'CLCTR   '
     C                   EVAL      SRTYPE  = 'M'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   WHEN      SrcName = 'PGMSRC  '
     C                   EVAL      SRTYPE  = 'P'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   When      SrcName = 'SVPSRC  '
     C                   EVAL      SRTYPE  = 'S'
     C                   EVAL      SRFILE  = ODOBNM
     C                   WRITE     UPSRCFD0
      *
     C                   ENDSL
      *
     C     GetNoLayerSrcEENDSR
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
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
