     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Initialisation Program for SDNOSRQD')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000003 - Initialisation Program for Nostro Extension File. *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 255049B *CREATE    Date 08Dec08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  255049B - Build SDNOSRQD Records                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR    - Initialise                                       *
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
 
      ** Midas SD Nostro details retrieval
     FSDNOSTL1  IF   E           K DISK
 
      ** Nostro Extension File
     FSDNOSRQD  O    E             DISK
 
      ** Logical file of Nostro Extensio File
     FSDNOSRQL0 IF   E           K DISK    RENAME(SDNOSRD0:SDNOSRD1)
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process files
 
     C                   EXSR      SRProcess
 
      ** End program
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process files                                    *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C** Read the entire Nostro File.
 
     C                   READ      SDNOSTL1
     C                   DOW       NOT %EOF(SDNOSTL1)
     C                   EVAL      DDBRCA = A7BRCD
     C                   EVAL      DDCCY  = A7CYCD
     C                   EVAL      DDACOD = A7ACCD
     C                   EVAL      COFRID = A7FRNT
     C                   EVAL      DDCUSN = A7CUST
     C                   EVAL      DDNONB = A7NONB
     C                   MOVEL     A7ACSN        DDACSQ
 
     C** Check if record is not existing in extension file.
 
     C     Key1          CHAIN     SDNOSRD1
     C                   IF        NOT %FOUND()
     C                   WRITE     SDNOSRD0
     C                   ENDIF
 
     C                   READ      SDNOSTL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Key list for LF/SDNOSRQL0
 
     C     KEY1          KLIST
     C                   KFLD                    DDBRCA
     C                   KFLD                    DDCCY
     C                   KFLD                    DDACOD
     C                   KFLD                    DDACSQ
     C                   KFLD                    DDCUSN
     C                   KFLD                    DDNONB
 
     C                   ENDSR
 
      *****************************************************************
