     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*OVR *  OVRDBF FILE(FTRTDXL0) TOFILE(T_GZRFT2EX)                     *
/*OVR *  OVRDBF FILE(FTCTDXL0) TOFILE(T_GZCCT2EX)                     *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Extension Table Delete Handler')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000010 - Midas FT Extension Table Delete Handler           *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSF003  *CREATE    Date 03Nov04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF003 - User Defined Forms                                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFTRTDXL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GZRFT2EX:FTRTDXD0)
      ** Midas FT Request for Transfer Detail Extension Table
 
     FFTCTDXL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GZCCT2EX:FTCTDXD0)
      ** Midas FT Customer Credit Transfer Detail Extension Table
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** FT Details Data Structures
     D GZFT101H      E DS                  EXTNAME(GZFT101HPD) PREFIX(H1)
     D GZFT102H      E DS                  EXTNAME(GZFT102HPD) PREFIX(H2)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S              7A
     D PPFName         S             10A
     D PZone           S             10A
     D PBIMG           S           4000A
 
      ** Key Fields
     D KZone           S                   LIKE(ZONE)
     D KRFTHdr         S                   LIKE(PRFTHDR)
     D KCCTID          S                   LIKE(PCCTID)
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Request for Transfer
 
     C                   IF        PPFName = 'FT101HPD'
 
     C                   MOVEL     PBIMG         GZFT101H
 
     C                   EVAL      KZone = PZone
     C                   EVAL      KRFTHdr = H1RFTID
     C     KRTDX         SETLL     FTRTDXL0
     C     KRTDX         READE     FTRTDXL0
 
     C                   DOW       NOT %EOF
     C                   DELETE    FTRTDXD0
     C     KRTDX         READE     FTRTDXL0
     C                   ENDDO
 
     C                   ENDIF
 
      ** Customer Credit Transfer
 
     C                   IF        PPFName = 'FT102HPD'
 
     C                   MOVEL     PBIMG         GZFT102H
 
     C                   EVAL      KZone = PZone
     C                   EVAL      KCCTID = H2CCTID
     C     KCTDX         SETLL     FTCTDXL0
     C     KCTDX         READE     FTCTDXL0
 
     C                   DOW       NOT %EOF
     C                   DELETE    FTCTDXD0
     C     KCTDX         READE     FTCTDXL0
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      PRetCode = '*ERROR '
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PPFName
     C                   PARM                    PZone
     C                   PARM                    PBIMG
 
      ** Key Lists
 
     C     KRTDX         KLIST
     C                   KFLD                    KZone
     C                   KFLD                    KRFTHdr
 
     C     KCTDX         KLIST
     C                   KFLD                    KZone
     C                   KFLD                    KCCTID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
